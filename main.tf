# ---- Provider ------------------------------------------------------------------------------------------------- #
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

terraform {
  backend "s3" {
    #insecure = true
    bucket                        = "BUCKET-NAME"
    region                        = "REGION-NAME"
    profile                       = "default"
    key                           = "private-endpoint/private-endpoint.tfstate"
    shared_credentials_file       = "./key/credentials"
    skip_region_validation        = true
    skip_credentials_validation   = true
    skip_requesting_account_id    = true
    use_path_style                = true
    skip_s3_checksum              = true
    skip_metadata_api_check       = true
    # use_unsigned_payload          = true
    endpoints                     = { s3 = "https://NAMESPACE.compat.objectstorage.REGION-NAME.oraclecloud.com" } 
  }
}

module "private_endpoint" {
  source = "./private_endpoint"
    tenancy_ocid            = var.tenancy_ocid
    private_endpoint_config = var.private_endpoint_config
    defined_tags            = var.defined_tags
    data_all_compartments   = local.data_all_compartments
}

module "data_compartment_level_1" {
  source      = "./data/compartment/level_1"
  compartment_id = var.tenancy_ocid
}

module "data_compartment_level_2" {
  source      = "./data/compartment/level_2"
  compartments_map_level_1 = length(module.data_compartment_level_1.compartments_map_level_1) > 0 ? module.data_compartment_level_1.compartments_map_level_1 : {}
}

module "data_compartment_level_3" {
  source      = "./data/compartment/level_3"
  compartments_map_level_2 = length(module.data_compartment_level_2.compartments_map_level_2) > 0 ? module.data_compartment_level_2.compartments_map_level_2 : {}
}

module "data_compartment_level_4" {
  source      = "./data/compartment/level_4"
  compartments_map_level_3 = length(module.data_compartment_level_3.compartments_map_level_3) > 0 ? module.data_compartment_level_3.compartments_map_level_3 : {}
}

module "data_compartment_level_5" {
  source      = "./data/compartment/level_5"
  compartments_map_level_4 = length(module.data_compartment_level_4.compartments_map_level_4) > 0 ? module.data_compartment_level_4.compartments_map_level_4 : {}
}

module "data_compartment_level_6" {
  source      = "./data/compartment/level_6"
  compartments_map_level_5 = length(module.data_compartment_level_5.compartments_map_level_5) > 0 ? module.data_compartment_level_5.compartments_map_level_5 : {}
}