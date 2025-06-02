resource "azurerm_resource_group" "rg" {
  name     = var.workshop_name
  location = "westeurope"
  tags     = {
          "BillingIdentifier"   = "00000"
          "BusinessContact"     = "AZURE"
          "CreatedOn"           = "2024-08-01"
          "EnvironmentInstance" = "001"
          "EnvironmentType"     = "AZURE"
          "ManagedBy"           = "AZURE"
          "Market"              = "AZR"
          "ProjectCode"         = "9999999"
          "ReviewDate"          = "2024-10-30"
          "ServiceName"         = "AZURE"
  }
}

resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
  tags                     = {

          "Compliance"              = "AZURE"
          "DataClassification"      = "AZURE"
          "DeploymentType"          = "Manual"
          "EnvironmentInstance"     = "001"
          "EnvironmentType"         = "AZURE"
          "ReviewDate"              = "2024-10-30"
          "SplunkMonitoringEnabled" = "FALSE"
  }


  lifecycle {
    ignore_changes = [
      tags["CreatedOn"], tags["ReviewDate"]
    ]

  }
}

resource "azurerm_storage_table" "st" {
  name                 = var.table_name
  storage_account_name = azurerm_storage_account.sa.name
}

/*
data "external" "sas_token" {
  program = [
    "${path.module}/generate_sas.sh",
    azurerm_storage_account.sa.name
  ]
}
*/

data "external" "sas_token" {
  program = [
    "pwsh.exe",
    "-ExecutionPolicy", "Bypass",
    "-File",
    "${path.module}/generate_sas.ps1",
    azurerm_storage_account.sa.name
  ]
}

output "table_sas_url" {
  value = "https://${azurerm_storage_account.sa.name}.table.core.windows.net/${azurerm_storage_table.st.name}?${data.external.sas_token.result.sas}"
}

variable "workshop_name" {
  description = "Name of the workshop"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "table_name" {
  description = "Name of the azure table"
  type        = string
}
