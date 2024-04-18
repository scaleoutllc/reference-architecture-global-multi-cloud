terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "5.38.0"
    }
  }
}

provider "oci" {
  region              = "us-chicago-1"
  config_file_profile = "scaleout"
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaaqmdyo455h7pgzmgvsn5ue4dg73oxhp47udjc66c3vlg5h7wyzvsa"
}

output "show-ads" {
  value = data.oci_identity_availability_domains.ads.availability_domains
}
