# How to make use of Azure Lighthouse
## Pre-requisites

- [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.1)
- [Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#winget)

## Architecture

See article on Microsoft Docs [here](https://docs.microsoft.com/en-us/azure/lighthouse/concepts/architecture)

## Deployment steps

### The Service Provider
Must provide:
- their tenant ID
- the Object ID of the Security Group containing the human and non-human identities that will control the customer subscription
- The role definition id they want to be assigned on the customer subscription
```powershell
(Get-AzRoleDefinition -Name Contributor).id
```

### The customer of the Managed Services Provider
1. Clone this repo locally and change the working directory to the root of the git repo.
```bash
git clone git@github.com:it-delivery/azure-lighthouse.git
cd azure-lighthouse
```
2. Alter the file [managedServices.params.json](https://github.com/it-delivery/azure-lighthouse/blob/main/templates/managedServices.params.json) with the details provided by the MSP.

    - Replace the string `11111111-1111-1111-1111-111111111111` with the Tenant Id provided by the MSP
    - Replace the string `22222222-2222-2222-2222-222222222222` with the Object Id of the Security Group in the MSP tenant that you will allow to manage your subscription.
    - Replace the string `33333333-3333-3333-3333-333333333333` with the Role Definition Id provided by the MSP as in their tenant.
    - Replace the string `LighthouseAdminAgents` with the Name of the Security Group in the MSP tenant that you will allow to manage your subscription.

3. Connect to Azure by running ```Connect-AzAccount```
4. Select the right subscription to give permissions to the MSP

```powershell
Get-AzSubscription
Select-AzSubscription <guid>
```

5. Deploy the bicep template with the updated parameters file

```powershell
New-AzDeployment -TemplateFile .\templates\managedServices.template.bicep -TemplateParameterFile .\templates\managedServices.params.json -Location westeurope -Verbose
```