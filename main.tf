terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 4.35.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "~> 3.4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {
}

# Data source used to get the current subscription's ID.
data "azurerm_subscription" "current" {

}

# Creates an application registration using Entra ID
resource "azuread_application" "hcpt_app" {
  display_name = "hcpt-app-marifw"
}

# Creates a service principal associated with the previously created
# application registration.
resource "azuread_service_principal" "hcpt_service_principal" {
  client_id = azuread_application.hcpt_app.client_id
}

# Creates a role assignment which controls the permissions the service
# principal has within the Azure subscription.
resource "azurerm_role_assignment" "name" {
  principal_id = azuread_service_principal.hcpt_service_principal.object_id
  scope = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
}

# Creates a federated identity credential which ensures that the given
# workspace will be able to authenticate to Azure for the "plan" run phase.
resource "azuread_application_federated_identity_credential" "hcpt_federated_credential_plan" {
  application_id = azuread_application.hcpt_app.id
  issuer = "https://${var.hcpt_hostname}"
  display_name = "hcpt-app-marifw-credential-plan"
  subject = "organization:${var.hcpt_organization_name}:project:${var.hcpt_project_name}:workspace:${var.hcpt_workspace_name}:run_phase:plan"
  audiences = [var.hcpt_azure_audience]
}

# Creates a federated identity credential which ensures that the given
# workspace will be able to authenticate to Azure for the "apply" run phase.
resource "azuread_application_federated_identity_credential" "hcpt_federated_credential_apply" {
  application_id = azuread_application.hcpt_app.id
  issuer = "https://${var.hcpt_hostname}"
  display_name = "hcpt-app-marifw-credential-apply"
  subject = "organization:${var.hcpt_organization_name}:project:${var.hcpt_project_name}:workspace:${var.hcpt_workspace_name}:run_phase:apply"
  audiences = [var.hcpt_azure_audience]
}