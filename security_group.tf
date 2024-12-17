# Groupe de sécurité pour les serveurs web
resource "outscale_security_group" "web_sg" {
  description         = "Web server security group"
  security_group_name = "web-sg"
  net_id              = outscale_net.vpc.net_id
}

# Règle pour autoriser HTTP (port 80) depuis partout
resource "outscale_security_group_rule" "web_http_rule" {
  flow               = "Inbound"
  security_group_id  = outscale_security_group.web_sg.security_group_id
  ip_protocol        = "tcp"
  from_port_range    = 80
  to_port_range      = 80
  ip_range           = var.ip_range_full
}

# Règle pour autoriser SSH (port 22) depuis le bastion
resource "outscale_security_group_rule" "web_ssh_rule" {
  flow               = "Inbound"
  security_group_id  = outscale_security_group.web_sg.security_group_id
  ip_protocol        = "tcp"
  from_port_range    = 22
  to_port_range      = 22
  ip_range           = var.ip_range_public_subnet # Sous-réseau public du bastion
}

# Règle pour autoriser tout le trafic sortant
resource "outscale_security_group_rule" "web_egress_rule" {
  flow               = "Outbound"
  security_group_id  = outscale_security_group.web_sg.security_group_id
  ip_protocol        = "-1" # Tous les protocoles
  from_port_range    = 0
  to_port_range      = 0
  ip_range           = var.ip_range_full
}


# Groupe de sécurité pour la machine bastion
resource "outscale_security_group" "bastion_sg" {
  description         = "Bastion security group"
  security_group_name = "bastion-sg"
  net_id              = outscale_net.vpc.net_id
}

# Règle pour autoriser SSH (port 22) depuis partout
resource "outscale_security_group_rule" "bastion_ssh_rule" {
  flow               = "Inbound"
  security_group_id  = outscale_security_group.bastion_sg.security_group_id
  ip_protocol        = "tcp"
  from_port_range    = 22
  to_port_range      = 22
  ip_range           = var.ip_range_full
}

# Règle pour autoriser tout le trafic sortant
resource "outscale_security_group_rule" "bastion_egress_rule" {
  flow               = "Outbound"
  security_group_id  = outscale_security_group.bastion_sg.security_group_id
  ip_protocol        = "-1" # Tous les protocoles
  from_port_range    = 0
  to_port_range      = 0
  ip_range           = var.ip_range_full
}
