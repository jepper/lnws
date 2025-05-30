/*
Before running terraform/tofu export the following variables

Linux
export TF_VAR_storage_account_name="{storageaccount}"
export TF_VAR_table_name="{tablename}"
export ARM_SUBSCRIPTION_ID="1f9651ed-b982-4fc9-8e6e-169a694af2cc"

Powershell
$env:TF_VAR_storage_account_name="{storageaccount}"
$env:TF_VAR_table_name="{tablename}"
$env:ARM_SUBSCRIPTION_ID="1f9651ed-b982-4fc9-8e6e-169a694af2cc"
*/

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.27"
    }
  }
}

provider "azurerm" {
  features {}
}
