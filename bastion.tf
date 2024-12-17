resource "outscale_vm" "bastion" {
  image_id = var.bastion_image
  vm_type = var.bastion_type
  keypair_name = outscale_keypair.my_keypair.keypair_name
  security_group_ids = [outscale_security_group.bastion_sg.security_group_id]
  subnet_id = outscale_subnet.public_subnet.subnet_id

  tags {
    key = "name"
    value = "bastion"
  }
}
