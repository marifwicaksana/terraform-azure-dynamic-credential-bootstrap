variable "hcpt_azure_audience" {
  type        = string
  default     = "api://AzureADTokenExchange"
  description = "The audience value to use in run identity tokens"
}


variable "hcpt_hostname" {
  type        = string
  default     = "app.terraform.io"
  description = "The hostname of the HCP Terraform (or TFE instance) you'd like to use with Azure"
}

variable "hcpt_organization_name" {
  type        = string
  description = "The name of your Terraform Cloud organization"
}

variable "hcpt_project_name" {
  type        = string
  description = "The project under which a workspace will be created"
}

variable "hcpt_workspace_name" {
  type        = string
  description = "The name of the workspace that you'd like to create and connect to Azure"
}