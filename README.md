# Federation Brokering

This is a small terraform configuration to setup a federation brokering scenario using Microsoft Entra ID (as Outbound Federation) and Keycloak (as Inbound Federation).
Additionaly it creates an import mapper for the xms_pl (preferredLanguage) attribute and sends the imported user attribute to the client application as claim *language*

The flow looks like this:

1. User goes to https://cat.irbe.ch
2. Enter Provider URL: `https://keycloak-url/realms/entraid`, Application ID: `cat` and start the flow
3. User gets redirected to Keycloak where `Sign in with entraidp` is chosen
4. User gets redirected to Microsoft Entra ID and enters credentials (if SSO is unavailable)
5. User is redirected to Keycloak where the Entra ID token is consumed and the user with attribute `language` is created
6. User is redirected to https://cat.irbe.ch where the tokens issued by Keycloak are shown

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.5 |
| azuread | ~>2.49 |
| keycloak | ~>4.4 |
| time | 0.11.1 |

## Providers

| Name | Version |
|------|---------|
| azuread | ~>2.49 |
| keycloak | ~>4.4 |
| time | 0.11.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.keycloak_broker](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_password.keycloak_broker](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password) | resource |
| [azuread_service_principal.keycloak_broker](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_service_principal.msgraph](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_service_principal_delegated_permission_grant.keycloak_broker](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal_delegated_permission_grant) | resource |
| [keycloak_custom_identity_provider_mapper.entra_idp_language](https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs/resources/custom_identity_provider_mapper) | resource |
| [keycloak_generic_protocol_mapper.cat_dedicated_scope_mapper_language](https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs/resources/generic_protocol_mapper) | resource |
| [keycloak_oidc_identity_provider.entra_idp](https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs/resources/oidc_identity_provider) | resource |
| [keycloak_openid_client.cat](https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs/resources/openid_client) | resource |
| [keycloak_realm.entra_idp](https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs/resources/realm) | resource |
| [time_rotating.keycloak_broker](https://registry.terraform.io/providers/hashicorp/time/0.11.1/docs/resources/rotating) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| entra\_client\_id | Entra ID service principal Client ID | `string` | n/a | yes |
| entra\_secret | Entra ID service principal Secret | `string` | n/a | yes |
| entra\_tenant\_id | Entra ID Tenant ID | `string` | n/a | yes |
| kc\_password | Keycloak admin password | `string` | n/a | yes |
| kc\_url | Keycloak URL | `string` | n/a | yes |
| kc\_username | Keycloak admin username | `string` | `"admin"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->