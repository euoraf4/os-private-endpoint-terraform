resource "oci_objectstorage_private_endpoint" "private_endpoint" {
  for_each = { for idx, private_endpoint in var.private_endpoint_config : private_endpoint.name => private_endpoint }
    # --- Required --- #
    compartment_id      = lookup(var.data_all_compartments, each.value.compartment_name, null)
    name                = each.value.name
    namespace           = data.oci_objectstorage_namespace.namespace.namespace
    subnet_id           = each.value.subnet_id
    prefix              = each.value.prefix

    dynamic "access_targets" {
      for_each = each.value.access_targets
      content {
        namespace       = data.oci_objectstorage_namespace.namespace.namespace
        compartment_id  = lookup(var.data_all_compartments, access_targets.value.compartment_name, null)
        bucket          = access_targets.value.bucket_name
      }
    }
    
    # --- Optional --- #
    private_endpoint_ip = each.value.private_endpoint_ip != null ? each.value.private_endpoint_ip : null
    nsg_ids             = each.value.nsg_ids != null ? each.value.nsg_ids : null
    additional_prefixes = each.value.additional_prefixes != null ? each.value.additional_prefixes : null
    defined_tags        = var.defined_tags
}