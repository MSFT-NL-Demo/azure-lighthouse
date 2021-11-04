param serviceProviderName string
param serviceProviderOfferDescription string
param serviceProviderTenantId string
param serviceProviderAuthorizations array

var registrationName = guid(serviceProviderName)
var assignmentName = guid(serviceProviderName)

resource registrationDefinition 'Microsoft.ManagedServices/registrationDefinitions@2020-02-01-preview' = {
  name: registrationName
  properties: {
    registrationDefinitionName: serviceProviderName
    description: serviceProviderOfferDescription
    managedByTenantId: serviceProviderTenantId
    authorizations: serviceProviderAuthorizations
  }
}

resource registrationAssignment 'Microsoft.ManagedServices/registrationAssignments@2020-02-01-preview' = {
  name: assignmentName
  dependsOn: [
    registrationDefinition
  ]
  properties: {
    registrationDefinitionId: resourceId('Microsoft.ManagedServices/registrationDefinitions/', registrationName)
  }
}
