# Akamai GTM Pool Configuration

A Terraform configuration for managing Akamai Global Traffic Management (GTM) properties dynamically. This setup allows you to define multiple pools with flexible datacenter configurations and automatically creates traffic targets based on available IPv4 and IPv6 addresses.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Variables](#variables)
- [Examples](#examples)
- [Adding New Pools](#adding-new-pools)
- [Adding New Datacenters](#adding-new-datacenters)
- [Important Notes](#important-notes)

## Overview

This Terraform configuration manages GTM properties with dynamic traffic target creation. Key features:

- **Dynamic Pools**: Define multiple pools (pool-2, pool-3, etc.) with flexible configurations
- **Datacenter Flexibility**: Assign datacenters to pools with optional IPv4/IPv6 addresses
- **Automatic Traffic Targets**: Dynamically creates traffic targets for each datacenter based on available addresses
- **Validation**: Ensures only valid datacenters are used
- **Scalable**: Easy to add new pools or modify existing ones
- **Multi-IP Support**: Each datacenter can have multiple IPs per protocol

## Prerequisites

### Required

1. **Akamai GTM Domain**: Must already exist in your Akamai account
   - The domain name is configured in `terraform.tfvars` as `gtm_domain_name`
   - Example: `cdn03.example.com`

2. **Terraform**: Version 1.0 or higher

3. **Akamai Terraform Provider**: Version 6.0 or higher
   - Requires valid Akamai API credentials

### Datacenters - MUST BE PRE-CREATED

⚠️ **IMPORTANT**: All datacenters referenced in this configuration must be **pre-created** in your Akamai GTM domain.

#### Predefined Datacenters

By default, this configuration expects three datacenters to exist in your GTM domain:

| Datacenter Code | Datacenter ID | Description          |
| --------------- | ------------- | -------------------- |
| `ams`           | 1             | Amsterdam datacenter |
| `rtm`           | 2             | Rotterdam datacenter |
| `utr`           | 3             | Utrecht datacenter   |

To verify these datacenters exist in your GTM domain:

```bash
# Using Akamai CLI or API
akamai gtm list-datacenters --domain=cdn03.example.com
```

#### Special Default Datacenters

Two additional datacenters are required for IPv4/IPv6 routing:

| Purpose         | Default ID | Variable          | Notes                              |
| --------------- | ---------- | ----------------- | ---------------------------------- |
| IPv4 Default DC | 5401       | `IPv4_default_dc` | Used by main pool for IPv4 routing |
| IPv6 Default DC | 5402       | `IPv6_default_dc` | Used by main pool for IPv6 routing |

These datacenters handle DNS request routing between the IPv4 and IPv6 specific pools. Ensure these IDs exist in your GTM domain.

### How to Lookup or Create Datacenters

#### Option 1: Using Akamai Control Center (GUI)

1. Log in to Akamai Control Center
2. Navigate to **GTM > Domains**
3. Select your GTM domain
4. Go to **Datacenters** tab
5. View existing datacenters and their IDs
6. Create new datacenters if needed (note the assigned IDs)

#### Option 2: Using Akamai API

```bash
# Get all datacenters in your domain
curl -X GET "https://akzz-configgtm-api.luna.akamaiapis.net/config-gtm/v1/domains/{domain-name}/datacenters" \
  -H "Authorization: Bearer {access-token}"

# Example response:
# {
#   "datacenters": [
#     {
#       "datacenterId": 1,
#       "dataCenterName": "Amsterdam",
#       "city": "Amsterdam",
#       ...
#     },
#     {
#       "datacenterId": 2,
#       "dataCenterName": "Rotterdam",
#       ...
#     }
#   ]
# }
```

#### Option 3: Using Terraform Import

If datacenters exist but aren't managed by Terraform, you can import them:

```bash
# Import datacenter resource
terraform import akamai_gtm_datacenter.amsterdam {domain-name}:{datacenter-id}
```

## Architecture

This configuration creates a three-level GTM hierarchy:

```
GTM Domain: cdn03.example.com
├── Pool: pool-2 (Main router - QTR type)
│   ├── Traffic Target → IPv4 DC (5401) → pool-2-ipv4
│   └── Traffic Target → IPv6 DC (5402) → pool-2-ipv6
│
├── Pool: pool-2-ipv4 (IPv4 weighted round-robin)
│   ├── Traffic Target → AMS DC (1) → 1.1.1.2
│   ├── Traffic Target → RTM DC (2) → 2.2.2.3
│   └── Traffic Target → UTR DC (3) → 3.3.3.4
│
└── Pool: pool-2-ipv6 (IPv6 weighted round-robin)
    ├── Traffic Target → AMS DC (1) → fd12:3456:789a:0001::2
    └── Traffic Target → UTR DC (3) → fd12:3456:789a:0003::2
```

### Resource Types

1. **Main Pool (QTR Type)**: Routes traffic to IPv4 or IPv6 specific pools based on DNS query type
2. **IPv4 Pool**: Weighted round-robin across IPv4-enabled datacenters
3. **IPv6 Pool**: Weighted round-robin across IPv6-enabled datacenters

## Getting Started

### 1. Configure Akamai Credentials

Set up Akamai API credentials (typically done via `.edgerc` file):

```bash
mkdir -p ~/.akamai-cli
cat > ~/.akamai-cli/.edgerc << 'EOF'
[default]
client_secret = {your-client-secret}
host = {your-api-host}
access_token = {your-access-token}
client_token = {your-client-token}
EOF
chmod 600 ~/.akamai-cli/.edgerc
```

### 2. Update Configuration

Edit `terraform.tfvars` with your settings:

```hcl
# Specify your GTM domain
gtm_domain_name = "cdn03.example.com"

# Define pools with datacenters and IP addresses
pool_servers = {
  "pool-2" = {
    "ams" = {
      ipv4 = ["1.1.1.2"]
      ipv6 = ["fd12:3456:789a:0001::2"]
    }
    "rtm" = {
      ipv4 = ["2.2.2.3"]
    }
    "utr" = {
      ipv4 = ["3.3.3.4"]
      ipv6 = ["fd12:3456:789a:0003::2"]
    }
  }
}
```

### 3. Verify Datacenter IDs (CRITICAL)

Before applying, verify that all datacenters exist in your GTM domain:

```bash
# Option A: Check via Akamai API
akamai gtm list-datacenters --domain=cdn03.example.com

# Option B: Check in terraform.tfvars and variables.tf
# - Ensure ams=1, rtm=2, utr=3 exist
# - Ensure IPv4 DC 5401 and IPv6 DC 5402 exist
```

### 4. Initialize and Validate

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Review planned changes
terraform plan
```

### 5. Apply Configuration

```bash
# Apply the configuration
terraform apply

# Confirm when prompted
```

## Configuration

### Main Configuration Files

| File               | Purpose                                                 |
| ------------------ | ------------------------------------------------------- |
| `pool-2.tf`        | Defines GTM pool resources with dynamic traffic targets |
| `variables.tf`     | Variable definitions and validation rules               |
| `terraform.tfvars` | Your configuration values (customize this)              |
| `outputs.tf`       | Output definitions (currently commented out)            |
| `providers.tf`     | Provider configuration                                  |

## Variables

### `gtm_domain_name` (Required)

The name of your Akamai GTM domain.

```hcl
gtm_domain_name = "cdn03.example.com"
```

### `pool_servers` (Required)

Map of pools with datacenter configurations.

**Structure:**

```hcl
pool_servers = {
  "pool-name" = {
    "datacenter-code" = {
      ipv4 = optional(list(string))  # Optional: list of IPv4 addresses
      ipv6 = optional(list(string))  # Optional: list of IPv6 addresses
    }
  }
}
```

**Validation:**

- Datacenter codes must match entries in `var.datacenter_ids`
- Validation is case-sensitive (use lowercase: ams, rtm, utr)
- At least one of ipv4 or ipv6 must be specified per datacenter

### `datacenter_ids` (Optional)

Predefined map of datacenter codes to their IDs.

**Default:**

```hcl
datacenter_ids = {
  "ams" = 1
  "rtm" = 2
  "utr" = 3
}
```

**Customization:**
To add additional datacenters, modify `variables.tf`:

```hcl
variable "datacenter_ids" {
  default = {
    "ams" = 1
    "rtm" = 2
    "utr" = 3
    "fra" = 4  # New Frankfurt datacenter
  }
}
```

### `IPv4_default_dc` and `IPv6_default_dc` (Optional)

Default datacenters for IPv4/IPv6 routing.

**Defaults:**

```hcl
IPv4_default_dc = 5401
IPv6_default_dc = 5402
```

These are special datacenters that route traffic between the IPv4 and IPv6 specific pools. Override if your GTM domain uses different IDs.

## Examples

### Example 1: Basic Single Pool with Three Datacenters

```hcl
gtm_domain_name = "cdn03.example.com"

pool_servers = {
  "pool-2" = {
    "ams" = {
      ipv4 = ["1.1.1.2"]
      ipv6 = ["fd12:3456:789a:0001::2"]
    }
    "rtm" = {
      ipv4 = ["2.2.2.3"]
    }
    "utr" = {
      ipv4 = ["3.3.3.4"]
      ipv6 = ["fd12:3456:789a:0003::2"]
    }
  }
}
```

This creates:

- `pool-2`: Main router
- `pool-2-ipv4`: Serves 1.1.1.2 (ams), 2.2.2.3 (rtm), 3.3.3.4 (utr)
- `pool-2-ipv6`: Serves fd12:3456:789a:0001::2 (ams), fd12:3456:789a:0003::2 (utr)

### Example 2: Multiple Pools

```hcl
gtm_domain_name = "cdn03.example.com"

pool_servers = {
  "pool-2" = {
    "ams" = {
      ipv4 = ["1.1.1.2"]
      ipv6 = ["fd12:3456:789a:0001::2"]
    }
    "rtm" = {
      ipv4 = ["2.2.2.3"]
    }
  }
  "pool-3" = {
    "ams" = {
      ipv4 = ["1.1.3.2"]
      ipv6 = ["fd12:3456:789a:0011::2"]
    }
    "rtm" = {
      ipv4 = ["2.2.3.3"]
      ipv6 = ["fd12:3456:789a:0022::2"]
    }
    "utr" = {
      ipv4 = ["3.3.4.4"]
      ipv6 = ["fd12:3456:789a:0033::2"]
    }
  }
}
```

This creates 6 pools total:

- pool-2, pool-2-ipv4, pool-2-ipv6
- pool-3, pool-3-ipv4, pool-3-ipv6

### Example 3: Multiple IPs Per Datacenter

```hcl
pool_servers = {
  "pool-2" = {
    "ams" = {
      ipv4 = ["1.1.1.2", "1.1.1.3", "1.1.1.4"]  # Multiple IPs
      ipv6 = ["fd12:3456:789a:0001::2", "fd12:3456:789a:0001::3"]
    }
    "rtm" = {
      ipv4 = ["2.2.2.3"]
    }
  }
}
```

All IPs in the list are served from the same datacenter.

### Example 4: IPv4-Only Datacenter

```hcl
pool_servers = {
  "pool-2" = {
    "ams" = {
      ipv4 = ["1.1.1.2"]
      ipv6 = ["fd12:3456:789a:0001::2"]
    }
    "rtm" = {
      ipv4 = ["2.2.2.3"]  # No IPv6 for Rotterdam
    }
  }
}
```

RTM datacenter will only be included in the IPv4 pool, not in the IPv6 pool.

## Adding New Pools

To add a new pool, simply add an entry to `pool_servers` in `terraform.tfvars`:

```hcl
pool_servers = {
  "pool-2" = {
    "ams" = { ipv4 = ["1.1.1.2"] }
  }
  "pool-4" = {  # New pool
    "ams" = { ipv4 = ["1.1.4.2"], ipv6 = ["fd12:3456:789a:0044::2"] }
    "rtm" = { ipv4 = ["2.2.4.3"] }
    "utr" = { ipv4 = ["3.3.4.4"] }
  }
}
```

Terraform will automatically create:

- `pool-4` (main router)
- `pool-4-ipv4` (IPv4 weighted round-robin)
- `pool-4-ipv6` (IPv6 weighted round-robin)

## Adding New Datacenters

### Step 1: Create Datacenter in Akamai GTM

Using Akamai Control Center or API, create a new datacenter and note its ID.

Example: Frankfurt datacenter with ID 4

### Step 2: Update `datacenter_ids` in `variables.tf`

```hcl
variable "datacenter_ids" {
  description = "..."
  type        = map(number)
  default = {
    "ams" = 1
    "rtm" = 2
    "utr" = 3
    "fra" = 4  # Add this line
  }
}
```

### Step 3: Use in Pool Configuration

```hcl
pool_servers = {
  "pool-2" = {
    "ams" = { ipv4 = ["1.1.1.2"] }
    "rtm" = { ipv4 = ["2.2.2.3"] }
    "utr" = { ipv4 = ["3.3.3.4"] }
    "fra" = { ipv4 = ["4.4.4.4"] }  # Use new datacenter
  }
}
```

### Step 4: Apply

```bash
terraform plan
terraform apply
```

## Important Notes

### ⚠️ Critical Prerequisites

1. **GTM Domain Must Exist**: The domain specified in `gtm_domain_name` must already exist in your Akamai account. Terraform does not create domains.

2. **Datacenters Must Pre-Exist**: All datacenters referenced in `pool_servers` must be created in your GTM domain before running `terraform apply`. This includes:
   - Primary datacenters (ams, rtm, utr) - IDs must match your GTM domain
   - Default datacenters (5401 for IPv4, 5402 for IPv6)

3. **Datacenter ID Mapping**: The IDs in `datacenter_ids` variable must match the actual datacenter IDs in your Akamai GTM domain. Verify before applying.

### Validation

The configuration includes validation to ensure:

- All datacenter names are lowercase and match `datacenter_ids`
- Case-sensitive validation (AMS ≠ ams)
- At least one of ipv4 or ipv6 is specified per datacenter
- Error messages clearly list valid datacenter options

To test validation without applying:

```bash
terraform validate
```

### Terraform State

The Terraform state file contains sensitive information. Protect it:

```bash
# Don't commit to version control
echo "terraform.tfstate*" >> .gitignore

# Use remote state for team environments
# terraform {
#   backend "s3" {
#     bucket = "terraform-state"
#     key    = "gtm/prod.tfstate"
#   }
# }
```

### DNS Hierarchy

When configuring your DNS CNAME to use these pools:

- Point A record (IPv4) to: `pool-2-ipv4.{domain}`
- Point AAAA record (IPv6) to: `pool-2-ipv6.{domain}`
- Or point generic CNAME to: `pool-2.{domain}` (auto-routes based on query type)

### Monitoring and Maintenance

After deployment, monitor your pools:

- GTM > Domains > {domain} > Properties > {pool-name}
- Check traffic targets and health status
- Review logs for DNS query patterns

### Troubleshooting

**Error: "datacenter not found"**

- Verify datacenter IDs in your GTM domain match `datacenter_ids`
- Use Akamai Control Center to check current IDs

**Error: "Invalid value for variable"**

- Check datacenter names in pool_servers are lowercase
- Verify they exist in `datacenter_ids`

**Traffic targets not created**

- Ensure at least one pool has IPv4 addresses for IPv4 pool
- Ensure at least one pool has IPv6 addresses for IPv6 pool
- Empty protocol pools will error

## Support and References

- [Akamai GTM Documentation](https://techdocs.akamai.com/gtm/docs/traffic-management-solution)
- [Terraform Akamai Provider](https://registry.terraform.io/providers/akamai/akamai/latest/docs)
- [GTM API Reference](https://techdocs.akamai.com/gtm-api/reference)

## License

This configuration is provided as-is. Customize as needed for your environment.
