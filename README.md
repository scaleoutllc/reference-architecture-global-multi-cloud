# global multi cloud infrastructure
> reference implementation

## Introduction
This repository showcases automated infrastructure management supporting
services running in redundant regions globally on multiple cloud providers.
This architecture is only approprite for teams with a high degree of
operational maturity working at organizations with a compelling business
case for its usage. Also note that this architecture is not production
ready from a security standpoint. It serves as an example for routing only.

### Domain Layout
The first step in implementing this architecture is to establish a root
domain for internal development. This implementation uses Cloudflare for
the root DNS zone to illustrate integration with a DNS provider other than
the providers used to run services.

```
wescaleout.cloud
```

> *At the time of this writing Cloudflare does not support the creation of
DNS subdomain zones (e.g. `dev.wescaleout.cloud`) without an enterprise
account. To support ease of demonstration and testing by community members,
AWS/Route53 has been chosen for managing all DNS below the root zone. Any
terraform-capable DNS provider that supports subdomain zones would work
equally well.*

For each layer of subdomains a new zone is created and delegated from
the one above. Though not strictly necessary, this allows DNS for each
area of the organization to be managed independently by the teams that
utilize them. It also makes it trivial within the infrastructure code
to manage DNS across multiple providers if desired.

#### Subdomain Delegation
First, delegate a subdomain for a working environment (e.g `dev`, `preprod`
etc). For the purposes of this introduction, we will focus on development,
and thus create the following:

```
dev.wescaleout.cloud
```

Next, delegate a subdomain for a team that will use development infrastructure.
This implementation uses the team name `team`. The corresponding subdomain is:

```
team.dev.wescaleout.cloud
```

Next, choose which global locations and cloud providers will be supported and 
delegate subdomains for all combinations that result. This implementation uses
AWS and GCP with equivalent regions in US and Australia. The corresponding
subdomains are as follows:

**Provider Specific**

*Requests to these domains will flow to services running in the specified
provider at the location nearest to the requestor.*
```
aws.team.dev.wescaleout.cloud
gcp.team.dev.wescaleout.cloud
```

**Region Specific**

*Requests to these domains will flow to services running in the specified
region, load balanced between cloud providers.*
```
us.team.dev.wescaleout.cloud
au.team.dev.wescaleout.cloud
```

**Fully Specified**

*Requests to these domains will flow to the exact provider & region specified.*
```
aws-us.team.dev.wescaleout.cloud
aws-au.team.dev.wescaleout.cloud
gcp-us.team.dev.wescaleout.cloud
gcp-au.team.dev.wescaleout.cloud
```