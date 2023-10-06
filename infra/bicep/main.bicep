// --------------------------------------------------------------------------------
// Main Bicep file that creates all of the Azure Resources for one environment
// --------------------------------------------------------------------------------
// To deploy this Bicep manually:
// 	 az login
//   az account set --subscription <subscriptionId>
//   az deployment group create -n main-deploy-20231006T0800Z --resource-group rg_playwright_testing --template-file 'main.bicep' --parameters appName=lll-playwright environmentCode=demo apiKey=something webAPIScope=api://xxxxxGUIDxxxxx/.default webAPIUrl=https://xxxxApimNamexxxx.azure-api.net/WeatherForecast adDomain=lyleluppes.onmicrosoft.com adTenantId=16b3c013-d300-468d-ac64-7eda0820b6d3 adClientId=ceb4d687-6cb2-42a0-99b0-53de66c04f3b
// --------------------------------------------------------------------------------
param appName string = ''
@allowed(['azd','gha','azdo','dev','demo','qa','stg','ct','prod'])
param environmentCode string = 'azd'
param location string = resourceGroup().location

param storageSku string = 'Standard_LRS'
param runDateTime string = utcNow()
param webSiteSku string = 'B1'

param webAPIScope string = '' // 'api://xxxxxGUIDxxxxx/.default'
param webAPIUrl string = '' // 'https://xxxxApimNamexxxx.azure-api.net/WeatherForecast'

param apiKey string = ''

param adInstance string = environment().authentication.loginEndpoint // 'https://login.microsoftonline.com/'
param adDomain string = ''
param adTenantId string = ''
param adClientId string = ''
param adCallbackPath string = '/signin-oidc'

// --------------------------------------------------------------------------------
var deploymentSuffix = '-${runDateTime}'
var commonTags = {         
  LastDeployed: runDateTime
  Application: appName
  Environment: environmentCode
}

// --------------------------------------------------------------------------------
module resourceNames 'resourcenames.bicep' = {
  name: 'resourcenames${deploymentSuffix}'
  params: {
    appName: appName
    environmentCode: environmentCode
  }
}
// --------------------------------------------------------------------------------
module logAnalyticsWorkspaceModule 'loganalyticsworkspace.bicep' = {
  name: 'logAnalytics${deploymentSuffix}'
  params: {
    logAnalyticsWorkspaceName: resourceNames.outputs.logAnalyticsWorkspaceName
    location: location
    commonTags: commonTags
  }
}

// --------------------------------------------------------------------------------
module storageModule 'storageaccount.bicep' = {
  name: 'storage${deploymentSuffix}'
  params: {
    storageSku: storageSku
    storageAccountName: resourceNames.outputs.storageAccountName
    location: location
    commonTags: commonTags
  }
}

module webSiteModule 'website.bicep' = {
  name: 'webSite${deploymentSuffix}'
  params: {
    webSiteName: resourceNames.outputs.webSiteName
    location: location
    appInsightsLocation: location
    commonTags: commonTags
    sku: webSiteSku
    environmentCode: environmentCode
    workspaceId: logAnalyticsWorkspaceModule.outputs.id
  }
}

// In a Linux app service, any nested JSON app key like AppSettings:MyKey needs to be 
// configured in App Service as AppSettings__MyKey for the key name. 
// In other words, any : should be replaced by __ (double underscore).
// NOTE: See https://learn.microsoft.com/en-us/azure/app-service/configure-common?tabs=portal  
module webSiteAppSettingsModule 'websiteappsettings.bicep' = {
  name: 'webSiteAppSettings${deploymentSuffix}'
  params: {
    webAppName: webSiteModule.outputs.name
    appInsightsKey: webSiteModule.outputs.appInsightsKey
    customAppSettings: {
      WebAPIScope: webAPIScope
      WebAPIUrl: webAPIUrl
      ApiKey: apiKey
      AzureAD__Instance: adInstance
      AzureAD__Domain: adDomain
      AzureAD__TenantId: adTenantId
      AzureAD__ClientId: adClientId
      AzureAD__CallbackPath: adCallbackPath
    }
  }
}
