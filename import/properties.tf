resource "akamai_gtm_property" "pool3" {
  domain                      = akamai_gtm_domain.cdn03_great-demo_nl.name
  name                        = "pool3"
  type                        = "ranked-failover"
  ipv6                        = false
  score_aggregation_type      = "worst"
  stickiness_bonus_percentage = 0
  stickiness_bonus_constant   = 0
  use_computed_targets        = false
  balance_by_download_score   = false
  dynamic_ttl                 = 60
  handout_limit               = 0
  handout_mode                = "normal"
  failover_delay              = 0
  failback_delay              = 0
  ghost_demand_reporting      = false
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.Clone__3__of_Default_Datacenter.datacenter_id
    enabled       = true
    weight        = 0
    servers       = ["3.3.3.3"]
    precedence    = 0
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.Clone__4__of_NY.datacenter_id
    enabled       = true
    weight        = 0
    servers       = ["2.2.2.2"]
    precedence    = 1
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.Clone__5__of_NY.datacenter_id
    enabled       = true
    weight        = 0
    servers       = ["1.1.1.1"]
    precedence    = 2
  }
  depends_on = [
    akamai_gtm_datacenter.Clone__3__of_Default_Datacenter,
    akamai_gtm_datacenter.Clone__4__of_NY,
    akamai_gtm_datacenter.Clone__5__of_NY,
    akamai_gtm_domain.cdn03_great-demo_nl
  ]
}

resource "akamai_gtm_property" "demo-pool" {
  domain                      = akamai_gtm_domain.cdn03_great-demo_nl.name
  name                        = "demo-pool"
  type                        = "weighted-round-robin"
  ipv6                        = false
  score_aggregation_type      = "worst"
  stickiness_bonus_percentage = 0
  stickiness_bonus_constant   = 0
  use_computed_targets        = false
  balance_by_download_score   = false
  dynamic_ttl                 = 30
  handout_limit               = 2
  handout_mode                = "normal"
  failover_delay              = 0
  failback_delay              = 0
  ghost_demand_reporting      = false
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.Clone__3__of_Default_Datacenter.datacenter_id
    enabled       = true
    weight        = 1
    servers       = ["pool3.cdn03.great-demo.nl", "pool1.cdn03.great-demo.nl", "pool2.cdn03.great-demo.nl"]
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.Clone__4__of_NY.datacenter_id
    enabled       = true
    weight        = 1
    servers       = ["pool1.cdn03.great-demo.nl", "pool3.cdn03.great-demo.nl", "pool2.cdn03.great-demo.nl"]
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.Clone__5__of_NY.datacenter_id
    enabled       = true
    weight        = 1
    servers       = ["pool1.cdn03.great-demo.nl", "pool3.cdn03.great-demo.nl", "pool2.cdn03.great-demo.nl"]
  }
  depends_on = [
    akamai_gtm_datacenter.Clone__3__of_Default_Datacenter,
    akamai_gtm_datacenter.Clone__4__of_NY,
    akamai_gtm_datacenter.Clone__5__of_NY,
    akamai_gtm_domain.cdn03_great-demo_nl
  ]
}

resource "akamai_gtm_property" "pool1" {
  domain                      = akamai_gtm_domain.cdn03_great-demo_nl.name
  name                        = "pool1"
  type                        = "ranked-failover"
  ipv6                        = false
  score_aggregation_type      = "worst"
  stickiness_bonus_percentage = 0
  stickiness_bonus_constant   = 0
  use_computed_targets        = false
  balance_by_download_score   = false
  dynamic_ttl                 = 60
  handout_limit               = 0
  handout_mode                = "normal"
  failover_delay              = 0
  failback_delay              = 0
  ghost_demand_reporting      = false
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.Clone__3__of_Default_Datacenter.datacenter_id
    enabled       = true
    weight        = 0
    servers       = ["1.1.1.1"]
    precedence    = 0
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.Clone__4__of_NY.datacenter_id
    enabled       = true
    weight        = 0
    servers       = ["2.2.2.2"]
    precedence    = 1
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.Clone__5__of_NY.datacenter_id
    enabled       = true
    weight        = 0
    servers       = ["3.3.3.3"]
    precedence    = 2
  }
  depends_on = [
    akamai_gtm_datacenter.Clone__3__of_Default_Datacenter,
    akamai_gtm_datacenter.Clone__4__of_NY,
    akamai_gtm_datacenter.Clone__5__of_NY,
    akamai_gtm_domain.cdn03_great-demo_nl
  ]
}

resource "akamai_gtm_property" "pool-ipv6" {
  domain                      = akamai_gtm_domain.cdn03_great-demo_nl.name
  name                        = "pool-ipv6"
  type                        = "weighted-round-robin"
  ipv6                        = true
  score_aggregation_type      = "worst"
  stickiness_bonus_percentage = 0
  stickiness_bonus_constant   = 0
  use_computed_targets        = false
  balance_by_download_score   = false
  dynamic_ttl                 = 60
  handout_limit               = 2
  handout_mode                = "normal"
  failover_delay              = 0
  failback_delay              = 0
  ghost_demand_reporting      = false
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.RTM.datacenter_id
    enabled       = true
    weight        = 1
    servers       = ["fd12:3456:789a:0002::1", "fd12:3456:789a:0002::3", "fd12:3456:789a:0002::2"]
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.NY.datacenter_id
    enabled       = true
    weight        = 2
    servers       = ["fd12:3456:789a:0001::2", "fd12:3456:789a:0001::1", "fd12:3456:789a:0001::3"]
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.Clone__3__of_Default_Datacenter.datacenter_id
    enabled       = true
    weight        = 1
    servers       = ["fd12:3456:789a:0003::1", "fd12:3456:789a:0003::2", "fd12:3456:789a:0003::3"]
  }
  depends_on = [
    akamai_gtm_datacenter.RTM,
    akamai_gtm_datacenter.NY,
    akamai_gtm_datacenter.Clone__3__of_Default_Datacenter,
    akamai_gtm_domain.cdn03_great-demo_nl
  ]
}

resource "akamai_gtm_property" "pool" {
  domain                      = akamai_gtm_domain.cdn03_great-demo_nl.name
  name                        = "pool"
  type                        = "qtr"
  ipv6                        = false
  score_aggregation_type      = "worst"
  stickiness_bonus_percentage = 0
  stickiness_bonus_constant   = 0
  use_computed_targets        = false
  balance_by_download_score   = false
  dynamic_ttl                 = 60
  handout_limit               = 0
  handout_mode                = "normal"
  failover_delay              = 0
  failback_delay              = 0
  ghost_demand_reporting      = false
  traffic_target {
    datacenter_id = data.akamai_gtm_default_datacenter.default_datacenter_5401.datacenter_id
    enabled       = true
    weight        = 1
    servers       = []
    handout_cname = "pool-ipv4.cdn03.great-demo.nl"
  }
  traffic_target {
    datacenter_id = data.akamai_gtm_default_datacenter.default_datacenter_5402.datacenter_id
    enabled       = true
    weight        = 1
    servers       = []
    handout_cname = "pool-ipv6.cdn03.great-demo.nl"
  }
  depends_on = [
    data.akamai_gtm_default_datacenter.default_datacenter_5401,
    data.akamai_gtm_default_datacenter.default_datacenter_5402,
    akamai_gtm_domain.cdn03_great-demo_nl
  ]
}

resource "akamai_gtm_property" "pool-ipv4" {
  domain                      = akamai_gtm_domain.cdn03_great-demo_nl.name
  name                        = "pool-ipv4"
  type                        = "weighted-round-robin"
  ipv6                        = false
  score_aggregation_type      = "worst"
  stickiness_bonus_percentage = 0
  stickiness_bonus_constant   = 0
  use_computed_targets        = false
  balance_by_download_score   = false
  dynamic_ttl                 = 30
  handout_limit               = 2
  handout_mode                = "normal"
  failover_delay              = 0
  failback_delay              = 0
  ghost_demand_reporting      = false
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.RTM.datacenter_id
    enabled       = true
    weight        = 1
    servers       = ["2.2.2.2"]
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.NY.datacenter_id
    enabled       = true
    weight        = 1
    servers       = ["1.1.1.1"]
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.Clone__3__of_Default_Datacenter.datacenter_id
    enabled       = true
    weight        = 1
    servers       = ["3.3.3.3"]
  }
  depends_on = [
    akamai_gtm_datacenter.RTM,
    akamai_gtm_datacenter.NY,
    akamai_gtm_datacenter.Clone__3__of_Default_Datacenter,
    akamai_gtm_domain.cdn03_great-demo_nl
  ]
}

resource "akamai_gtm_property" "_" {
  domain                      = akamai_gtm_domain.cdn03_great-demo_nl.name
  name                        = "*"
  type                        = "geographic"
  ipv6                        = false
  score_aggregation_type      = "worst"
  stickiness_bonus_percentage = 0
  stickiness_bonus_constant   = 0
  use_computed_targets        = false
  balance_by_download_score   = false
  dynamic_ttl                 = 60
  map_name                    = "GEO map for wildcard"
  handout_limit               = 0
  handout_mode                = "normal"
  failover_delay              = 0
  failback_delay              = 0
  ghost_demand_reporting      = false
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.NY.datacenter_id
    enabled       = true
    weight        = 1
    servers       = []
    handout_cname = "pool.cdn03.clevercast.eu"
  }
  traffic_target {
    datacenter_id = data.akamai_gtm_default_datacenter.default_datacenter_5400.datacenter_id
    enabled       = true
    weight        = 0
    servers       = []
    handout_cname = "cclive-cdn03.akamaized.net"
  }
  depends_on = [
    akamai_gtm_datacenter.NY,
    data.akamai_gtm_default_datacenter.default_datacenter_5400,
    akamai_gtm_domain.cdn03_great-demo_nl
  ]
}

resource "akamai_gtm_property" "pool2" {
  domain                      = akamai_gtm_domain.cdn03_great-demo_nl.name
  name                        = "pool2"
  type                        = "ranked-failover"
  ipv6                        = false
  score_aggregation_type      = "worst"
  stickiness_bonus_percentage = 0
  stickiness_bonus_constant   = 0
  use_computed_targets        = false
  balance_by_download_score   = false
  dynamic_ttl                 = 60
  handout_limit               = 0
  handout_mode                = "normal"
  failover_delay              = 0
  failback_delay              = 0
  ghost_demand_reporting      = false
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.Clone__3__of_Default_Datacenter.datacenter_id
    enabled       = true
    weight        = 0
    servers       = ["3.3.3.3"]
    precedence    = 1
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.Clone__4__of_NY.datacenter_id
    enabled       = true
    weight        = 0
    servers       = ["2.2.2.2"]
    precedence    = 0
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.Clone__5__of_NY.datacenter_id
    enabled       = true
    weight        = 0
    servers       = ["1.1.1.1"]
    precedence    = 2
  }
  depends_on = [
    akamai_gtm_datacenter.Clone__3__of_Default_Datacenter,
    akamai_gtm_datacenter.Clone__4__of_NY,
    akamai_gtm_datacenter.Clone__5__of_NY,
    akamai_gtm_domain.cdn03_great-demo_nl
  ]
}

resource "akamai_gtm_property" "_" {
  domain                      = akamai_gtm_domain.cdn03_great-demo_nl.name
  name                        = "@"
  type                        = "static"
  ipv6                        = false
  score_aggregation_type      = "worst"
  stickiness_bonus_percentage = 0
  stickiness_bonus_constant   = 0
  use_computed_targets        = false
  balance_by_download_score   = false
  static_rr_set {
    type  = "SOA"
    ttl   = 86400
    rdata = ["n3-a1.aka-ns.net. hostmaster.cdn03.great-demo.nl 2025121200 3600 600 604800 300"]
  }
  static_rr_set {
    type  = "NS"
    ttl   = 86400
    rdata = ["n3-a1.aka-ns.net.", "n3-a26.aka-ns.net.", "n3-a3.aka-ns.net.", "n3-a6.aka-ns.net.", "n3-a7.aka-ns.net.", "n3-a8.aka-ns.net."]
  }
  dynamic_ttl            = 60
  handout_limit          = 0
  handout_mode           = "normal"
  failover_delay         = 0
  failback_delay         = 0
  ghost_demand_reporting = false
  depends_on = [
    akamai_gtm_domain.cdn03_great-demo_nl
  ]
}

