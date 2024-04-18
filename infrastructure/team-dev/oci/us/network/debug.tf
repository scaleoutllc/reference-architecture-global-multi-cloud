# resource "oci_core_instance" "debug" {
#   compartment_id      = local.compartment_id
#   availability_domain = oci_core_subnet.public[0].availability_domain
#   create_vnic_details {
#     assign_private_dns_record = true
#     assign_public_ip          = true
#     subnet_id                 = oci_core_subnet.public[0].id
#   }
#   display_name = "debug"
#   metadata = {
#     "ssh_authorized_keys" = file(pathexpand("~/.ssh/id_rsa.pub"))
#   }
#   shape = "VM.Standard.A1.Flex"
#   shape_config {
#     memory_in_gbs = 1
#     ocpus         = 1
#   }
#   source_details {
#     source_id   = "ocid1.image.oc1.eu-zurich-1.aaaaaaaabt5i2qa7sdt65orrb66anzyljybm3furr2q7ykxodt5zmfxqbyzq"
#     source_type = "image"
#   }
# }
# output "debug_public_ip" {
#   value = oci_core_instance.debug.public_ip
# }
