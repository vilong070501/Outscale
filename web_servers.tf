resource "outscale_vm" "web_server" {
  count             = var.web_server_count
  image_id          = var.image_id
  vm_type           = var.vm_type
  keypair_name      = outscale_keypair.my_keypair.keypair_name
  security_group_ids = [outscale_security_group.web_sg.security_group_id]
  subnet_id         = outscale_subnet.private_subnet.subnet_id

  tags {
    key = "name"
    value = "web-server-${count.index}"
  }
}

resource "null_resource" remoteExecProvisionerWFolder {
  count = var.web_server_count

  provisioner "file" {
    source      = "vm_startup.sh"
    destination = "/tmp/vm_startup.sh"
    connection {
      type        = "ssh"
      user        = "outscale"
      host        = outscale_vm.web_server[count.index].private_ip
      private_key = tls_private_key.my_key.private_key_pem
    }
  }

  provisioner "remote-exec" {
    inline = ["sudo bash /tmp/vm_startup.sh ${count.index}"]
    connection {
      type        = "ssh"
      user        = "outscale"
      host        = outscale_vm.web_server[count.index].private_ip
      private_key = tls_private_key.my_key.private_key_pem
    }
  }
}

