terraform {
  required_version = "~> 1.5"
  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "~>4.4"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.49"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.1"
    }
  }
}

provider "azuread" {
  tenant_id     = var.entra_tenant_id
  client_id     = var.entra_client_id
  client_secret = var.entra_secret
}

provider "keycloak" {
  client_id = "admin-cli"
  username  = var.kc_username
  password  = var.kc_password
  url       = var.kc_url
}
