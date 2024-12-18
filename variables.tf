variable "access_key_id" {}
variable "secret_key_id" {}
variable "region" {
  default = "eu-west-2"
}

variable "ip_range_net" {
  default = "10.0.0.0/16"
}
variable "ip_range_public_subnet" {
  default = "10.0.1.0/24"
}
variable "ip_range_private_subnet" {
  default = "10.0.2.0/24"
}
variable "ip_range_full" {
  default = "0.0.0.0/0"
}
variable "decription" {
  default = "Groupe de sécurité pour le projet Outscale"
}
variable "security_group_name" {
  default = "terraform-security-group"
}
variable "image_id" {
  default = "ami-7b8d1702"
}
variable "vm_type" {
  default = "tinav4.c1r2p3"
}
variable "web_server_count" {
  default = 2
}
variable "load_balancer_name" {
  default = "public-load-balancer"
}
variable "load_balancer_type" {
  default = "internet-facing"
}
variable "bastion_image" {
  default = "ami-7b8d1702"
}
variable "bastion_type" {
  default = "tinav4.c1r2p3"
}
