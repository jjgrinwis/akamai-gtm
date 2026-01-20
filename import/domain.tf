terraform {
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = ">= 6.0.0"
    }
  }
  required_version = ">= 1.0"
}

provider "akamai" {
  edgerc         = var.edgerc_path
  config_section = var.config_section
}

resource "akamai_gtm_domain" "cdn03_great-demo_nl" {
  contract                  = var.contractid
  group                     = var.groupid
  name                      = "cdn03.great-demo.nl"
  type                      = "basic"
  comment                   = "test"
  email_notification_list   = ["jgrinwis@akamai.com"]
  default_timeout_penalty   = 25
  load_imbalance_percentage = 10
  default_error_penalty     = 75
  cname_coalescing_enabled  = true
  load_feedback             = false
  end_user_mapping_enabled  = false
  sign_and_serve            = false
}
