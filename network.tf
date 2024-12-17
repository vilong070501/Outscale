#creation du reseau virtuel
resource "outscale_net" "vpc" {
  ip_range = var.ip_range_net
    tags  {
    key = "name"
    value =  "vpc-main"
  }

}
#creation du sous reseau public
resource "outscale_subnet" "public_subnet" {
  net_id   = outscale_net.vpc.net_id
  ip_range = var.ip_range_public_subnet
  subregion_name = "${var.region}a"

  tags {
    key = "name"
    value = "public-subnet"
  }
}
#creation du sous réseau privé
resource "outscale_subnet" "private_subnet" {
  net_id   = outscale_net.vpc.net_id
  ip_range = var.ip_range_private_subnet
  subregion_name = "${var.region}a"

  tags {
    key = "name"
    value = "private-subnet"
  }
}
#internet service
resource "outscale_internet_service" "internet_service_as" {}

# Liaison du service internet
resource "outscale_internet_service_link" "igw_link" {
  internet_service_id = outscale_internet_service.internet_service_as.internet_service_id
  net_id              = outscale_net.vpc.net_id
}

resource "outscale_public_ip" "nat_ip" {
  tags {
    key = "name"
    value = "nat-public-ip"
  }
}

resource "outscale_nat_service" "nat" {
  subnet_id = outscale_subnet.public_subnet.subnet_id
  public_ip_id = outscale_public_ip.nat_ip.public_ip_id
}

resource "outscale_route_table" "route_table_public" {
  net_id = outscale_net.vpc.net_id

  tags {
    key = "name"
    value = "public-route-table"
  }
}

resource "outscale_route" "default_public" {
  route_table_id         = outscale_route_table.route_table_public.route_table_id
  destination_ip_range   = var.ip_range_full
  gateway_id             = outscale_internet_service.internet_service_as.internet_service_id
}

resource "outscale_route_table_link" "route_table_public_link" {
  route_table_id = outscale_route_table.route_table_public.route_table_id
  subnet_id      = outscale_subnet.public_subnet.subnet_id
}

resource "outscale_route_table" "route_table_private" {
  net_id = outscale_net.vpc.net_id

  tags {
    key = "name"
    value = "private-route-table"
  }
}

resource "outscale_route" "default_private" {
  route_table_id       = outscale_route_table.route_table_private.route_table_id
  destination_ip_range = var.ip_range_full
  nat_service_id       = outscale_nat_service.nat.nat_service_id
}

resource "outscale_route_table_link" "route_table_private_link" {
  route_table_id = outscale_route_table.route_table_private.route_table_id
  subnet_id      = outscale_subnet.private_subnet.subnet_id
}
