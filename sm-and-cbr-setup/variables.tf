variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "Region to provision all resources created by this example"
  default     = "us-south"
}

variable "prefix" {
  type        = string
  description = "Prefix to append to all resources created by this example"
  default     = "ra-sm-infra"
}

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example, if unset a new resource group will be created"
  default     = null
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "vpc_crn" {
  type = string
  description = "VPC CRN for binding the CBR Rule."
#  default = "crn:v1:bluemix:public:is:us-south:a/abac0df06b644a9cabc6e44f55b3880e::vpc:r006-5d74f001-2ed4-49ec-9b52-bc4458a127bb"
}