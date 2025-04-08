variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key this account authenticates to"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "Region where resources will be created"
  default     = "us-south"
}

variable "instance_id" {
  type        = string
  description = "SM Instance ID"
}

variable "provider_visibility" {
  description = "Set the visibility value for the IBM terraform provider. Supported values are `public`, `private`, `public-and-private`. [Learn more](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/guides/custom-service-endpoints)."
  type        = string
  default     = "private"

  validation {
    condition     = contains(["public", "private", "public-and-private"], var.provider_visibility)
    error_message = "Invalid visibility option. Allowed values are 'public', 'private', or 'public-and-private'."
  }
}
