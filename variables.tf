variable "gtm_domain_name" {
  description = "The name of the GTM domain to manage."
  type        = string
}

variable "datacenter_ids" {
  description = "Predefined map of datacenter names to their IDs. These are the only valid datacenter names that can be used in pool_servers."
  type        = map(number)
  default = {
    "ams" = 1
    "rtm" = 2
    "utr" = 3
  }
}

variable "pool_servers" {
  description = <<-EOT
    Map of GTM pools with their datacenter configurations.
    
    Structure:
      - Key: Pool name (e.g., "pool-2", "pool-3")
      - Value: Map of datacenters where:
        - Key: Datacenter name from predefined list ("ams", "rtm", "utr")
               These keys must match entries in var.datacenter_ids
        - Value: Object with:
          - ipv4: List of IPv4 addresses for this datacenter (optional)
          - ipv6: List of IPv6 addresses for this datacenter (optional)
    
    Benefits:
      - Simplified: No need to specify datacenter IDs - they're looked up automatically
      - Flexible: Add/remove datacenters without changing resource definitions
      - Scalable: Support multiple IP addresses per datacenter per protocol
      - Optional: Datacenters can have IPv4 only, IPv6 only, or both
      - Dynamic: Traffic targets are automatically created based on available IPs
      - Validated: Only predefined datacenter names (ams, rtm, utr) are accepted
    
    Example:
      pool_servers = {
        "pool-2" = {
          "ams" = {
            ipv4 = ["1.1.1.2", "1.1.1.3"]
            ipv6 = ["fd12:3456:789a:0002::2"]
          }
          "rtm" = {
            ipv4 = ["2.2.2.3"]
            # No IPv6 for this datacenter
          }
          "utr" = {
            ipv4 = ["3.3.3.4"]
            ipv6 = ["fd12:3456:789a:0003::2", "fd12:3456:789a:0003::3"]
          }
        }
      }
  EOT
  type = map(map(object({
    ipv4 = optional(list(string))
    ipv6 = optional(list(string))
  })))
  default = {
    "example-pool" = {
      "ams" = {
        ipv4 = ["192.0.2.1"]
        ipv6 = ["2001:db8::1"]
      }
      "rtm" = {
        ipv4 = ["192.0.2.2"]
        ipv6 = ["2001:db8::2"]
      }
    }
  }

  validation {
    condition = alltrue(flatten([
      for pool_name, pool_config in var.pool_servers : [
        for dc_name in keys(pool_config) : contains(keys(var.datacenter_ids), dc_name)
      ]
    ]))
    error_message = "All datacenter names in pool_servers must be defined in datacenter_ids. Valid datacenters are: ${join(", ", keys(var.datacenter_ids))}"
  }
}

# For the IP version selector resources, we need to define default IPv4 and IPv6 datacenters.
# This should already been created in your GTM config.action 
variable "IPv4_default_dc" {
  description = "The default IPv4 datacenter ID"
  type        = number
  default     = 5401
}

variable "IPv6_default_dc" {
  description = "The default IPv6 datacenter ID"
  type        = number
  default     = 5402
}
