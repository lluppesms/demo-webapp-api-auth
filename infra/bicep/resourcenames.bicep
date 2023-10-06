// --------------------------------------------------------------------------------
// Bicep file that builds all the resource names used by other Bicep templates
// --------------------------------------------------------------------------------
param appName string = ''
@allowed(['azd','gha','azdo','dev','demo','qa','stg','ci','ct','prod'])
param environmentCode string = 'azd'

// --------------------------------------------------------------------------------
var sanitizedEnvironment = toLower(environmentCode)
var sanitizedAppNameWithDashes = replace(replace(toLower(appName), ' ', ''), '_', '')
var sanitizedAppName = replace(replace(replace(toLower(appName), ' ', ''), '-', ''), '_', '')

// pull resource abbreviations from a common JSON file
var resourceAbbreviations = loadJsonContent('./resourceAbbreviations.json')

// --------------------------------------------------------------------------------
output logAnalyticsWorkspaceName string =  toLower('${sanitizedAppNameWithDashes}-logworkspace')
//output logAnalyticsWorkspaceName string =  toLower('${sanitizedAppNameWithDashes}-${sanitizedEnvironment}-logworkspace')
//var webSiteName                         = toLower('${sanitizedAppNameWithDashes}-${sanitizedEnvironment}')
var webSiteName                         = toLower('${sanitizedAppNameWithDashes}-web')
output webSiteName string               = webSiteName
output webSiteAppServicePlanName string = webSiteName
output webSiteAppInsightsName string    = webSiteName
// output webSiteAppServicePlanName string = '${webSiteName}-${resourceAbbreviations.appServicePlanSuffix}'
// output webSiteAppInsightsName string    = '${webSiteName}-${resourceAbbreviations.appInsightsSuffix}'
var apiSiteName                         = toLower('${sanitizedAppNameWithDashes}-api')
output apiSiteName string               = apiSiteName
output apimName string                  = '${webSiteName}-${resourceAbbreviations.apimSuffix}'

// Key Vaults and Storage Accounts can only be 24 characters long
output storageAccountName string        = take('${sanitizedAppName}${resourceAbbreviations.storageAccountSuffix}${sanitizedEnvironment}', 24)
