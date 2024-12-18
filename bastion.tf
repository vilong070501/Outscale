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

# Création d'une IP public
resource "outscale_public_ip" "public_ip_bastion" {
  tags {
  key = "name"
  value = "public_ip_bastion"
  }
}
# Liaison de notre IP public avec notre VM
resource "outscale_public_ip_link" "public_ip_link_as" {
  vm_id = outscale_vm.bastion.vm_id
  public_ip = outscale_public_ip.public_ip_bastion.public_ip
}