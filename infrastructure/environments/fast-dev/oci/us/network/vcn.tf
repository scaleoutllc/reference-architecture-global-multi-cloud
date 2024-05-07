// This dataset returns an array of all internal OCI services in a
// non-deterministic order.
data "oci_core_services" "list" {}
locals {
  // This looks up the reference to "all" services in a (hopefully) stable
  // manner. This reference is used to give subnets in the VCN access to
  // ingress/egress with other OCI services.
  allServices = element([
    for item in data.oci_core_services.list.services :
    item if startswith(item.name, "All")
  ], 0)
}

resource "oci_core_vcn" "main" {
  compartment_id = var.compartment_id
  cidr_blocks    = [local.network.cidr]
  display_name   = local.name
  dns_label      = replace(local.name, "-", "")
}

resource "oci_core_internet_gateway" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  enabled        = true
  display_name   = local.name
}

resource "oci_core_nat_gateway" "private" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = local.name
}

resource "oci_core_service_gateway" "private" {
  compartment_id = var.compartment_id
  display_name   = local.name
  services {
    service_id = local.allServices.id
  }
  vcn_id = oci_core_vcn.main.id
}

resource "oci_core_default_route_table" "public" {
  display_name = "public-${local.name}"
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.public.id
  }
  manage_default_resource_id = oci_core_vcn.main.default_route_table_id
}

resource "oci_core_route_table" "private" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "private-${local.name}"
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_nat_gateway.private.id
  }
  route_rules {
    description       = "traffic to ${local.allServices.name}"
    destination_type  = "SERVICE_CIDR_BLOCK"
    destination       = local.allServices.cidr_block
    network_entity_id = oci_core_service_gateway.private.id
  }
}

resource "oci_core_security_list" "oci-core-services" {
  compartment_id = var.compartment_id
  display_name   = "${local.name}-oci-core-services"
  vcn_id         = oci_core_vcn.main.id
  ingress_security_rules {
    description = "from ${local.allServices.name}"
    protocol    = "6"
    source      = local.allServices.cidr_block
    source_type = "SERVICE_CIDR_BLOCK"
  }
  egress_security_rules {
    description      = "to ${local.allServices.name}"
    protocol         = "6"
    destination      = local.allServices.cidr_block
    destination_type = "SERVICE_CIDR_BLOCK"
  }
}
