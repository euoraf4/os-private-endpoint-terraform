data "oci_identity_compartments" "compartment_level_4" {
  for_each                    = var.compartments_map_level_3
    compartment_id            = each.value
    compartment_id_in_subtree = false
    state = "ACTIVE"
  
}

locals {
  list_compartments_map_level_4 = {
    for name, ocid in var.compartments_map_level_3 :
    name => {
      for sub_compartment in data.oci_identity_compartments.compartment_level_4[name].compartments :
      "${name}/${sub_compartment.name}" => sub_compartment.id
    }
  }
}

locals {
  # Flattening the map by merging all sub-maps
  compartments_map_level_4 = merge(
    [
      for parent_name, sub_map in local.list_compartments_map_level_4 :
      sub_map
    ]...
  )
}


