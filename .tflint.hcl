# Terraform Language (i.e. provider/plugin independent) rules see
# https://github.com/terraform-linters/tflint-ruleset-terraform/blob/main/docs/rules/README.md

# Disallow // comments in favor of #
# default: disabled
rule "terraform_comment_syntax" {
  enabled = true
}

# Disallow output declarations without description
# default: disabled
rule "terraform_documented_outputs" {
  enabled = true
}

# Disallow variable declarations without description
# default: disabled
rule "terraform_documented_variables" {
  enabled = true
}

# Enforces naming conventions for resources, data sources, etc
# default: disabled
rule "terraform_naming_convention" {
  enabled = true
}

# Ensure that a module complies with the Terraform Standard Module Structure
# default: disabled
rule "terraform_standard_module_structure" {
  enabled = true
}

# Check that all required_providers
# are used in the module
rule "terraform_unused_required_providers" {
   enabled = true
}