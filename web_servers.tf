resource "outscale_vm" "web_server" {
  count             = var.web_server_count
  image_id          = var.image_id
  vm_type           = var.vm_type
  keypair_name      = outscale_keypair.my_keypair.keypair_name
  security_group_ids = [outscale_security_group.web_sg.security_group_id]
  subnet_id         = outscale_subnet.private_subnet.subnet_id
  user_data = file("cloud-init-web-server.yml")

  tags {
    key = "name"
    value = "web-server-${count.index}"
  }
}

