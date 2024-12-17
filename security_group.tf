# Security Group for Bastion Host
resource "outscale_security_group" "bastion_sg" {
  description         = "Security group for Bastion Host"
  security_group_name = "bastion-sg"
  net_id              = outscale_net.vpc.net_id
}

# Rule to allow SSH access to Bastion Host from a specific IP range
resource "outscale_security_group_rule" "bastion_ssh" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.bastion_sg.security_group_id
  from_port_range   = "22"
  to_port_range     = "22"
  ip_protocol       = "tcp"
  ip_range          = "203.0.113.0/24" # Replace with your IP range
}

# Security Group for Web Servers
resource "outscale_security_group" "web_sg" {
  description         = "Security group for Web Servers"
  security_group_name = "web-sg"
  net_id              = outscale_net.vpc.net_id
}

# Rule to allow HTTP access to Web Servers from Load Balancer
resource "outscale_security_group_rule" "web_http" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.web_sg.security_group_id
  rules {
    from_port_range = "80"
    to_port_range   = "80"
    ip_protocol     = "tcp"
    security_groups_members {
      security_group_name = outscale_security_group.lb_sg.security_group_name
    }
  }
}

# Rule to allow SSH access to Web Servers from Bastion Host
resource "outscale_security_group_rule" "web_ssh" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.web_sg.security_group_id
  rules {
    from_port_range = "22"
    to_port_range   = "22"
    ip_protocol     = "tcp"
    security_groups_members {
      security_group_name = outscale_security_group.bastion_sg.security_group_name
    }
  }
}

# Security Group for Load Balancer
resource "outscale_security_group" "lb_sg" {
  description         = "Security group for Load Balancer"
  security_group_name = "lb-sg"
  net_id              = outscale_net.vpc.net_id
}

# Rule to allow public HTTP traffic to Load Balancer
resource "outscale_security_group_rule" "lb_http" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.lb_sg.security_group_id
  from_port_range   = "80"
  to_port_range     = "80"
  ip_protocol       = "tcp"
  ip_range          = "0.0.0.0/0" # Public access
}
