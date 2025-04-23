locals {
  data_all_compartments = merge(
    module.data_compartment_level_1.compartments_map_level_1,
    module.data_compartment_level_2.compartments_map_level_2,
    module.data_compartment_level_3.compartments_map_level_3,
    module.data_compartment_level_4.compartments_map_level_4,
    module.data_compartment_level_5.compartments_map_level_5,
    module.data_compartment_level_6.compartments_map_level_6,
    { "root" = var.tenancy_ocid },
  )
}

data "oci_identity_tenancy" "current" {
  tenancy_id = var.tenancy_ocid
}

output "private_endpoint_ids" {
  value = module.private_endpoint.private_endpoint_ids
}

output "tenancy_name" {
  value = "===============================> TENANCY: ${data.oci_identity_tenancy.current.name} <==============================="
}