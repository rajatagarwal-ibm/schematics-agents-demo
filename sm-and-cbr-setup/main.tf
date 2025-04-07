module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.6"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

data "ibm_iam_account_settings" "iam_account_settings" {
}

# CBR
module "cbr_zone" {
  source           = "terraform-ibm-modules/cbr/ibm//modules/cbr-zone-module"
  version          = "1.29.0"
  name             = "${var.prefix}-CBR-zone"
  zone_description = "CBR Network zone representing VPC"
  account_id       = data.ibm_iam_account_settings.iam_account_settings.account_id
  addresses = [{
    type  = "vpc", # to bind a specific vpc to the zone
    value = var.vpc_crn,
  }]
}

# Secrets Manager
module "secrets_manager" {
  source               = "terraform-ibm-modules/secrets-manager/ibm"
  version              = "2.0.0"
  resource_group_id    = module.resource_group.resource_group_id
  region               = var.region
  secrets_manager_name = "${var.prefix}-secrets-manager" #tfsec:ignore:general-secrets-no-plaintext-exposure
  sm_service_plan      = "trial"
  sm_tags              = var.resource_tags
  secrets = [
    {
      secret_group_name = "${var.prefix}-secret-group"
      secrets = [{
        secret_name             = "${var.prefix}-dummy-secret"
        secret_type             = "arbitrary"
        secret_payload_password = "dummy-password"
      }]
    }
  ]
  cbr_rules = [
    {
      description      = "${var.prefix}-secrets-manager access only from vpc"
      enforcement_mode = "enabled"
      account_id       = data.ibm_iam_account_settings.iam_account_settings.account_id
      rule_contexts = [{
        attributes = [
          {
            "name" : "endpointType",
            "value" : "private"
          },
          {
            name  = "networkZoneId"
            value = module.cbr_zone.zone_id
          }]
      }]
      operations = [{
        api_types = [{
          api_type_id = "crn:v1:bluemix:public:context-based-restrictions::::api-type:"
        }]
      }]
    }
  ]
}
