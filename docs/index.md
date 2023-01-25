# What is Azure Lighthouse?

Azure Lighthouse enables multi-tenant management with scalability, higher automation, and enhanced governance across resources.

With Azure Lighthouse, service providers can deliver managed services using [comprehensive and robust tooling built into the Azure platform](https://github.com/MicrosoftDocs/azure-docs/tree/master/articles/lighthouse/concepts/architecture.md). Customers maintain control over who has access to their tenant, which resources they can access, and what actions can be taken. [Enterprise organizations](https://github.com/MicrosoftDocs/azure-docs/tree/master/articles/lighthouse/concepts/enterprise.md) managing resources across multiple tenants can also use Azure Lighthouse to streamline management tasks.

[Cross-tenant management experiences](https://github.com/MicrosoftDocs/azure-docs/tree/master/articles/lighthouse/concepts/cross-tenant-management-experience.md) lets you work more efficiently with Azure services like [Azure Policy](https://github.com/MicrosoftDocs/azure-docs/tree/master/articles/lighthouse/how-to/policy-at-scale.md), [Azure Sentinel](https://github.com/MicrosoftDocs/azure-docs/tree/master/articles/lighthouse/how-to/manage-sentinel-workspaces.md), [Azure Arc](https://github.com/MicrosoftDocs/azure-docs/tree/master/articles/lighthouse/how-to/manage-hybrid-infrastructure-arc.md), and many more. Users can see what changes were made and by whom [in the activity log](https://github.com/MicrosoftDocs/azure-docs/tree/master/articles/lighthouse/how-to/view-service-provider-activity.md), which is stored in the customer's tenant and can be viewed by users in the managing tenant.

![Overview diagram of Azure Lighthouse](https://raw.githubusercontent.com/MicrosoftDocs/azure-docs/main/articles/lighthouse/media/azure-lighthouse-overview.jpg)
    

## Capabilities

Azure Lighthouse includes multiple ways to help streamline engagement and management:

- **Azure delegated resource management**: [Manage your customers' Azure resources securely from within your own tenant](https://github.com/MicrosoftDocs/azure-docs/tree/master/articles/lighthouse/concepts/architecture.md), without having to switch context and control planes. Customer subscriptions and resource groups can be delegated to specified users and roles in the managing tenant, with the ability to remove access as needed.
- **New Azure portal experiences**: View cross-tenant information in the [**My customers** page](https://github.com/MicrosoftDocs/azure-docs/tree/master/articles/lighthouse/how-to/view-manage-customers.md) in the Azure portal. A corresponding [**Service providers** page](https://github.com/MicrosoftDocs/azure-docs/tree/master/articles/lighthouse/how-to/view-manage-service-providers.md) lets customers view and manage their service provider access.
- **Azure Resource Manager templates**: Use ARM templates to [onboard delegated customer resources](https://github.com/MicrosoftDocs/azure-docs/tree/master/articles/lighthouse/how-to/onboard-customer.md) and [perform cross-tenant management tasks](https://github.com/MicrosoftDocs/azure-docs/tree/master/articles/lighthouse/samples/index.md).
- **Managed Service offers in Azure Marketplace**: [Offer your services to customers](https://github.com/MicrosoftDocs/azure-docs/tree/master/articles/lighthouse/concepts/managed-services-offers.md) through private or public offers, and automatically onboard them to Azure Lighthouse.


# Pricing and availability

There are no additional costs associated with using Azure Lighthouse to manage Azure resources. Any Azure customer or partner can use Azure Lighthouse.


# How to make use of Azure Lighthouse?

## Pre-requisites

- [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.1)
- [Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#winget)

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
git clone git@github.com:MSFT-NL-Demo/azure-lighthouse.git
cd azure-lighthouse
```
2. Alter the file [managedServices.params.json](https://github.com/MSFT-NL-Demo/azure-lighthouse/blob/main/templates/managedServices.params.json) with the details provided by the MSP.

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
