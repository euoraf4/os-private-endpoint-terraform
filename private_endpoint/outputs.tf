output "private_endpoint_ids" {
  value = { for private_endpoint_name, private_endpoint in oci_objectstorage_private_endpoint.private_endpoint : private_endpoint_name => private_endpoint.id }
}