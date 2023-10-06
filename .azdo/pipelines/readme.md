# Azure DevOps Deployment Template Notes

## 1. Azure DevOps Template Definitions

- **build-infra-deploy-pipeline.yml:** Deploys the Azure resources, builds the website and API code, then deploys the website and API to the Azure App Service

---

## 2. Deploy Environments

These YML files were designed to run as multi-stage environment deploys (i.e. DEV/QA/PROD). Each Azure DevOps environments can have permissions and approvals defined. For example, DEV can be published upon change, and QA/PROD environments can require an approval before any changes are made.

---

## 3. Setup Steps

- [Create Azure DevOps Service Connections](https://docs.luppes.com/CreateServiceConnections/)

- [Create Azure DevOps Environments](https://docs.luppes.com/CreateDevOpsEnvironments/)

- Create Azure DevOps Variable Groups -- see next step

- [Create Azure DevOps Pipeline(s)](https://docs.luppes.com/CreateNewPipeline/)

- Run the infra-and-website-pipeline.yml pipeline to deploy the project to an Azure subscription.

---

## 4. These pipelines needs a variable group named "Playwright"

To create this variable group, customize and run this command in the Azure Cloud Shell:

``` bash
   az login

   az pipelines variable-group create 
     --organization=https://dev.azure.com/<yourAzDOOrg>/ 
     --project='<yourAzDOProject>' 
     --name Playwright 
     --variables 
         azureSubscription: 'yourSubscriptionName'
         webAppName: 'xxx-playwright-web'
         apiAppName: 'xxx-playwright-api'
         apiAppAPIMName: 'xxx-playwright-apim'
         organizationName: 'yourOrgName'
         adminEmail: 'youremail@yourdomain.com'
         resourceGroupName: 'rg_playwright_testing'
         region: 'East US'
         apiKey: 'someGuid'
         webAPIScope: 'api://xxxxxGUIDxxxxx/.default'
         webAPIUrl: 'https://xxxxApimNamexxxx.azure-api.net/WeatherForecast'
         adDomain: 'yourdomain.onmicrosoft.com'
         adTenantId: 'someGuid'
         adClientId: 'someGuid'
```
