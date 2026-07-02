provider "azurerm" {
  features {}
}

variables {
  resource_group_name = "rg-example"
  location            = "australiaeast"
}

run "vault" {
  module {
    source = "./.."
  }
  command = apply

  variables {
    name     = "bvault-tftest-dev"
    identity = { type = "SystemAssigned" }
  }

  assert {
    condition     = output.name == "bvault-tftest-dev"
    error_message = "Vault name does not match the requested name."
  }

  assert {
    condition     = output.principal_id != null
    error_message = "Vault managed identity principal ID is not populated."
  }
}
