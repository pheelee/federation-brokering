resource "azuread_service_principal" "msgraph" {
  client_id    = "00000003-0000-0000-c000-000000000000"
  use_existing = true
}

resource "azuread_application" "keycloak_broker" {
  display_name            = "Keycloak Broker"
  description             = "Test app for keycloak inbound federation tests"
  sign_in_audience        = "AzureADMyOrg"
  group_membership_claims = ["ApplicationGroup"]
  tags = [
    "HideApp",
    "WindowsAzureActiveDirectoryIntegratedApp",
  ]
  web {
    redirect_uris = [
      "${var.kc_url}/realms/entraid/broker/entraidp/endpoint"
    ]
  }
  api {
    mapped_claims_enabled = true
  }
  optional_claims {
    id_token {
      additional_properties = []
      essential             = false
      name                  = "groups"
    }
    id_token {
      additional_properties = []
      essential             = false
      name                  = "xms_pl"
    }
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"
    resource_access {
      id   = azuread_service_principal.msgraph.oauth2_permission_scope_ids["User.Read"]
      type = "Scope"
    }
    resource_access {
      id   = azuread_service_principal.msgraph.oauth2_permission_scope_ids["openid"]
      type = "Scope"
    }
    resource_access {
      id   = azuread_service_principal.msgraph.oauth2_permission_scope_ids["profile"]
      type = "Scope"
    }
    resource_access {
      id   = azuread_service_principal.msgraph.oauth2_permission_scope_ids["email"]
      type = "Scope"
    }
    resource_access {
      id   = azuread_service_principal.msgraph.oauth2_permission_scope_ids["offline_access"]
      type = "Scope"
    }

  }
}

resource "azuread_service_principal" "keycloak_broker" {
  client_id                    = azuread_application.keycloak_broker.client_id
  account_enabled              = true
  app_role_assignment_required = false
}

resource "time_rotating" "keycloak_broker" {
  rotation_days = 180
}

resource "azuread_application_password" "keycloak_broker" {
  application_id      = azuread_application.keycloak_broker.id
  rotate_when_changed = { rotation = time_rotating.keycloak_broker.id }
}

resource "azuread_service_principal_delegated_permission_grant" "keycloak_broker" {
  service_principal_object_id          = azuread_service_principal.keycloak_broker.object_id
  claim_values                         = ["User.Read", "openid", "profile", "email", "offline_access"]
  resource_service_principal_object_id = azuread_service_principal.msgraph.object_id
}

resource "keycloak_realm" "entra_idp" {
  realm             = "entraid"
  enabled           = true
  display_name      = "Entra IDP"
  display_name_html = "<b>Entra IDP</b>"
}

resource "keycloak_oidc_identity_provider" "entra_idp" {
  realm              = keycloak_realm.entra_idp.id
  alias              = "entraidp"
  authorization_url  = "https://login.microsoftonline.com/${var.entra_tenant_id}/oauth2/v2.0/authorize"
  token_url          = "https://login.microsoftonline.com/${var.entra_tenant_id}/oauth2/v2.0/token"
  client_id          = azuread_application.keycloak_broker.client_id
  client_secret      = azuread_application_password.keycloak_broker.value
  logout_url         = "https://login.microsoftonline.com/${var.entra_tenant_id}/oauth2/v2.0/logout"
  user_info_url      = "https://graph.microsoft.com/oidc/userinfo"
  validate_signature = true
  jwks_url           = "https://login.microsoftonline.com/${var.entra_tenant_id}/discovery/v2.0/keys"
  store_token        = false
  default_scopes     = "openid profile email"
  issuer             = "https://login.microsoftonline.com/${var.entra_tenant_id}/v2.0"
  sync_mode          = "IMPORT"
  extra_config = {
    "clientAuthMethod" = "client_secret_post"
  }
}

resource "keycloak_custom_identity_provider_mapper" "entra_idp_language" {
  realm                    = keycloak_realm.entra_idp.id
  name                     = "language-attribute-importer"
  identity_provider_alias  = keycloak_oidc_identity_provider.entra_idp.alias
  identity_provider_mapper = "oidc-user-attribute-idp-mapper"
  extra_config = {
    syncMode         = "FORCE"
    claim            = "xms_pl"
    "user.attribute" = "language"
  }
}

resource "keycloak_openid_client" "cat" {
  realm_id              = keycloak_realm.entra_idp.id
  client_id             = "cat"
  name                  = "Cat"
  enabled               = true
  access_type           = "PUBLIC"
  standard_flow_enabled = true
  valid_redirect_uris = [
    "https://cat.irbe.ch/oidc/callback",
  ]
}

resource "keycloak_generic_protocol_mapper" "cat_dedicated_scope_mapper_language" {
  realm_id        = keycloak_realm.entra_idp.id
  client_id       = keycloak_openid_client.cat.id
  name            = "language"
  protocol        = "openid-connect"
  protocol_mapper = "oidc-usermodel-attribute-mapper"
  config = {
    "introspection.token.claim" : "true",
    "userinfo.token.claim" : "true",
    "user.attribute" : "language",
    "id.token.claim" : "true",
    "access.token.claim" : "true",
    "claim.name" : "language",
    "jsonType.label" : "String"
  }
}
