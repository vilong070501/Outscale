resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits = "2048"
}
# Stockage de la clef privée
resource "local_file" "my_key" {
  content = tls_private_key.my_key.private_key_pem
  filename = "${path.module}/my_key.pem"
  file_permission = "0600"
}
# Import de la clef
resource "outscale_keypair" "my_keypair" {
  keypair_name = "outscale_terraform_project"
  public_key = tls_private_key.my_key.public_key_openssh
}