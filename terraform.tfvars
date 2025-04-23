# ---- Provider ------------------------------------------------------------------------------------------------- #
  tenancy_ocid     = ""
  user_ocid        = ""
  fingerprint      = ""
  region           = ""
  private_key_path = "./key/"

  private_endpoint_config = [ 
    {
      # --- Required --- #
      name                  = ""
      compartment_name      = ""
      subnet_id             = ""
      prefix                = ""
      access_targets = [
        {
          bucket_name       = ""
          compartment_name  = ""
        }
      ]
      # --- Optional --- #
      # private_endpoint_ip   = ""
      # additional_prefixes   = []
      # nsg_ids               = []
    }
  ]

  defined_tags = {
  }