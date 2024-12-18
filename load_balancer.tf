resource "outscale_load_balancer" "web_lb" {
  load_balancer_name = var.load_balancer_name
  subnets            = [outscale_subnet.public_subnet.subnet_id]
  security_groups    = [outscale_security_group.lb_sg.security_group_id]
  load_balancer_type = var.load_balancer_type

  listeners {
    backend_port           = 8080
    backend_protocol       = "HTTP"
    load_balancer_port     = 8080
    load_balancer_protocol = "HTTP" 
  }
  listeners {
    backend_port           = 80
    backend_protocol       = "TCP"
    load_balancer_protocol = "TCP"
    load_balancer_port     = 80
  }

  tags {
    key = "name"
    value = "web-lb"
  }
}

resource "outscale_load_balancer_vms" "web_lb_vms" {
  count              = var.web_server_count
  load_balancer_name = outscale_load_balancer.web_lb.load_balancer_name
  backend_vm_ids     = [outscale_vm.web_server[count.index].vm_id]
}

resource "outscale_load_balancer_attributes" "health_check_web_lb" {
  load_balancer_name = outscale_load_balancer.web_lb.load_balancer_name
  health_check {
    healthy_threshold = 10
    check_interval = 30
    path = "/"
    port = 80
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 5
  }
}
