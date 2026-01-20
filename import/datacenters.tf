resource "akamai_gtm_datacenter" "Clone__5__of_NY" {
  domain                            = akamai_gtm_domain.cdn03_great-demo_nl.name
  nickname                          = "Clone (5) of NY"
  city                              = "New York"
  state_or_province                 = "NY"
  country                           = "US"
  latitude                          = 40.713047
  longitude                         = -74.00723
  clone_of                          = 2
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on = [
    akamai_gtm_domain.cdn03_great-demo_nl
  ]
}

resource "akamai_gtm_datacenter" "Clone__4__of_NY" {
  domain                            = akamai_gtm_domain.cdn03_great-demo_nl.name
  nickname                          = "Clone (4) of NY"
  city                              = "New York"
  state_or_province                 = "NY"
  country                           = "US"
  latitude                          = 40.713047
  longitude                         = -74.00723
  clone_of                          = 2
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on = [
    akamai_gtm_domain.cdn03_great-demo_nl
  ]
}

resource "akamai_gtm_datacenter" "NY" {
  domain                            = akamai_gtm_domain.cdn03_great-demo_nl.name
  nickname                          = "NY"
  city                              = "New York"
  state_or_province                 = "NY"
  country                           = "US"
  latitude                          = 40.713047
  longitude                         = -74.00723
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on = [
    akamai_gtm_domain.cdn03_great-demo_nl
  ]
}

resource "akamai_gtm_datacenter" "RTM" {
  domain                            = akamai_gtm_domain.cdn03_great-demo_nl.name
  nickname                          = "RTM"
  city                              = "Rotterdam"
  country                           = "NL"
  latitude                          = 51.922913
  longitude                         = 4.470585
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on = [
    akamai_gtm_domain.cdn03_great-demo_nl
  ]
}

resource "akamai_gtm_datacenter" "Clone__3__of_Default_Datacenter" {
  domain                            = akamai_gtm_domain.cdn03_great-demo_nl.name
  nickname                          = "Clone (3) of Default Datacenter"
  clone_of                          = 5400
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on = [
    akamai_gtm_domain.cdn03_great-demo_nl
  ]
}

data "akamai_gtm_default_datacenter" "default_datacenter_5400" {
  domain     = akamai_gtm_domain.cdn03_great-demo_nl.name
  datacenter = 5400
}

data "akamai_gtm_default_datacenter" "default_datacenter_5401" {
  domain     = akamai_gtm_domain.cdn03_great-demo_nl.name
  datacenter = 5401
}

data "akamai_gtm_default_datacenter" "default_datacenter_5402" {
  domain     = akamai_gtm_domain.cdn03_great-demo_nl.name
  datacenter = 5402
}

