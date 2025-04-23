variable "private_endpoint_config" {
  type = list(object({
    name              = string
    compartment_name  = string
    subnet_id         = string
    prefix            = string
    private_endpoint_ip = optional(string)
    nsg_ids = optional(list(string))
    additional_prefixes = optional(list(string))
    access_targets = list(object({
      compartment_name  = string
      bucket_name       = string
    }))    
  }))
}

variable "defined_tags" {
}

variable "tenancy_ocid" {
  type = string
}

variable "data_all_compartments" {
}