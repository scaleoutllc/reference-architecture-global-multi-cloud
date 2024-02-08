# global-multicloud-k8s
> reference implementation

## Domain / Nameserver Layout
```
cloud.wescaleout.com (AWS Route 53)
├── dev.cloud.wescaleout.com (AWS Route 53)
│   ├── australia.dev.cloud.wescaleout.com (AWS Route 53)
│   │   ├── aws.australia.dev.cloud.wescaleout.com (AWS Route 53)
│   │   ├── azure.australia.dev.cloud.wescaleout.com (Azure DNS Zone)
│   │   └── gcp.australia.dev.cloud.wescaleout.com (GCP Managed Zone)
│   └── us.cloud.wescaleout.com (AWS Route 53)
│       ├── aws.us.cloud.wescaleout.com (AWS Route 53)
│       ├── azure.us.cloud.wescaleout.com (Azure DNS Zone)
│       └── gcp.us.cloud.wescaleout.com (GCP Managed Zone)
└── prod.cloud.wescaleout.com (AWS Route 53)
    ├── australia.prod.cloud.wescaleout.com (AWS Route 53)
    │   ├── aws.australia.prod.cloud.wescaleout.com (AWS Route 53)
    │   ├── azure.australia.prod.cloud.wescaleout.com (Azure DNS Zone)
    │   └── gcp.australia.prod.cloud.wescaleout.com (GCP Managed Zone)
    └── us.prod.cloud.wescaleout.com (AWS Route 53)
        ├── aws.us.prod.cloud.wescaleout.com (AWS Route 53)
        ├── azure.us.prod.cloud.wescaleout.com (Azure DNS Zone)
        └── gcp.us.prod.cloud.wescaleout.com (GCP Managed Zone)
```

## Request Flow Expectations
To be authored.