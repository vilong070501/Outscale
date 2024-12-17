resource "outscale_vm" "bastion" {
  image_id = var.image_id
  vm_type = var.vm_type
  keypair_name = outscale_keypair.my_keypair.keypair_name
  security_group_ids = [outscale_security_group.bastion_sg.security_group_id] #to be completed
  subnet_id = outscale_subnet.public_subnet.subnet_id

  tags {
    key = "name"
    value = "bastion"
  }
}
