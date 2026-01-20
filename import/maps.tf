
resource "akamai_gtm_geomap" "GEO_map_for_wildcard" {
  domain = akamai_gtm_domain.cdn03_great-demo_nl.name
  default_datacenter {
    nickname      = "Default Mapping"
    datacenter_id = data.akamai_gtm_default_datacenter.default_datacenter_5400.datacenter_id
  }
  assignment {
    nickname      = "EU"
    datacenter_id = akamai_gtm_datacenter.NY.datacenter_id
    countries     = ["DE", "PT", "DK", "LT", "LU", "HR", "LV", "UA", "HU", "MC", "MD", "ME", "IE", "MK", "EE", "AD", "IM", "MT", "IS", "AL", "IT", "VA", "ES", "EU", "AT", "JE", "RO", "NL", "BA", "NO", "RS", "BE", "FI", "RU", "BG", "FO", "FR", "SE", "SI", "BY", "SJ", "SK", "SM", "GB", "GE", "GG", "GI", "CH", "GR", "XK", "CY", "CZ", "PL", "LI", "TR"]
  }
  name = "GEO map for wildcard"
  depends_on = [
    akamai_gtm_datacenter.NY,
    akamai_gtm_domain.cdn03_great-demo_nl
  ]
}

