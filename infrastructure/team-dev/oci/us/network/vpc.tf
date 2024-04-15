data "oci_identity_availability_domains" "ads" {
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaaqmdyo455h7pgzmgvsn5ue4dg73oxhp47udjc66c3vlg5h7wyzvsa"
}

resource "oci_core_vcn" "main" {
  compartment_id = local.compartment_id
  cidr_blocks = [local.network.cidr]
  display_name = local.name
}

resource "oci_core_subnet" "public" {
  count = length(local.network.public_subnets)
  cidr_block = local.network.public_subnets[count.index]
  compartment_id = local.compartment_id
  vcn_id = oci_core_vcn.main.id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[count.index].name
  display_name = "${local.name}-public-${count.index}"
  prohibit_internet_ingress = false
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_subnet" "private" {
  count = length(local.network.private_subnets)
  cidr_block = local.network.private_subnets[count.index]
  compartment_id = local.compartment_id
  vcn_id = oci_core_vcn.main.id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[count.index].name
  display_name = "${local.name}-private-${count.index}"
  prohibit_internet_ingress = true
  prohibit_public_ip_on_vnic = true
}
