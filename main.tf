resource "akamai_gtm_property" "ipv4" {
  for_each = var.pool_servers

  domain                 = var.gtm_domain_name
  name                   = "${each.key}-ipv4"
  type                   = "weighted-round-robin"
  handout_limit          = 1
  handout_mode           = "normal"
  ipv6                   = false
  score_aggregation_type = "worst"

  dynamic "traffic_target" {
    for_each = {
      for dc_name, dc_config in each.value :
      dc_name => dc_config if dc_config.ipv4 != null
    }
    content {
      datacenter_id = var.datacenter_ids[traffic_target.key]
      enabled       = true
      weight        = 1
      servers       = traffic_target.value.ipv4
    }
  }
}

resource "akamai_gtm_property" "ipv6" {
  for_each = var.pool_servers

  domain                 = var.gtm_domain_name
  name                   = "${each.key}-ipv6"
  type                   = "weighted-round-robin"
  handout_limit          = 1
  handout_mode           = "normal"
  ipv6                   = true
  score_aggregation_type = "worst"

  dynamic "traffic_target" {
    for_each = {
      for dc_name, dc_config in each.value :
      dc_name => dc_config if dc_config.ipv6 != null
    }
    content {
      datacenter_id = var.datacenter_ids[traffic_target.key]
      enabled       = true
      weight        = 1
      servers       = traffic_target.value.ipv6
    }
  }
}

resource "akamai_gtm_property" "main" {
  for_each = var.pool_servers

  domain                 = var.gtm_domain_name
  name                   = each.key
  type                   = "qtr"
  score_aggregation_type = "worst"
  handout_limit          = 0
  handout_mode           = "normal"
  traffic_target {
    datacenter_id = var.IPv4_default_dc
    enabled       = true
    weight        = 1
    servers       = []
    handout_cname = "${each.key}-ipv4.${var.gtm_domain_name}"
  }
  traffic_target {
    datacenter_id = var.IPv6_default_dc
    enabled       = true
    weight        = 1
    servers       = []
    handout_cname = "${each.key}-ipv6.${var.gtm_domain_name}"
  }
  depends_on = [
    akamai_gtm_property.ipv4
  , akamai_gtm_property.ipv6]
}
