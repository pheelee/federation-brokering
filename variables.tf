variable "kc_username" {
  type        = string
  description = "Keycloak admin username"
  default     = "admin"
}
variable "kc_password" {
  type        = string
  description = "Keycloak admin password"
}
variable "kc_url" {
  type        = string
  description = "Keycloak URL"
}

variable "entra_tenant_id" {
  type        = string
  description = "Entra ID Tenant ID"
}

variable "entra_client_id" {
  type        = string
  description = "Entra ID service principal Client ID"
}

variable "entra_secret" {
  type        = string
  description = "Entra ID service principal Secret"
}
