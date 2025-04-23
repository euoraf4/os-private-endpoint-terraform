data "oci_identity_compartments" "compartment_level_1" {
    compartment_id = var.compartment_id
    compartment_id_in_subtree = false
    state = "ACTIVE"
}

locals {
  compartments_map_level_1 = {
    for compartment in data.oci_identity_compartments.compartment_level_1.compartments : compartment.name => compartment.id}
}

