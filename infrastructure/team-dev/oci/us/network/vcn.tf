data "oci_core_services" "all" {}

resource "oci_core_vcn" "main" {
  compartment_id = local.compartment_id
  cidr_blocks    = [local.network.cidr]
  display_name   = local.name
  dns_label      = replace(local.envName, "-", "")
}

resource "oci_core_internet_gateway" "public" {
  compartment_id = local.compartment_id
  vcn_id         = oci_core_vcn.main.id
  enabled        = true
  display_name   = local.name
}

resource "oci_core_nat_gateway" "private" {
  compartment_id = local.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = local.name
}

resource "oci_core_service_gateway" "private" {
  compartment_id = local.compartment_id
  display_name   = local.name
  services {
    service_id = data.oci_core_services.all.services[0].id
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
  compartment_id = local.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "private-${local.name}"
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_nat_gateway.private.id
  }
  route_rules {
    description       = "traffic to ${data.oci_core_services.all.services[0].name}"
    destination_type  = "SERVICE_CIDR_BLOCK"
    destination       = data.oci_core_services.all.services[0].cidr_block
    network_entity_id = oci_core_service_gateway.private.id
  }
}

resource "oci_core_security_list" "oci-core-services" {
  compartment_id = local.compartment_id
  display_name   = "${local.name}-oci-core-services"
  vcn_id         = oci_core_vcn.main.id
  egress_security_rules {
    description      = "to oci services"
    protocol         = "6"
    destination      = data.oci_core_services.all.services[0].cidr_block
    destination_type = "SERVICE_CIDR_BLOCK"
  }
}
