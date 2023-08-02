resource "openstack_networking_secgroup_v2" "opensearch_member" {
  name                 = var.member_group_name
  description          = "Security group for opensearch members"
  delete_default_rules = true
}

//Allow all outbound traffic from opensearch members
resource "openstack_networking_secgroup_rule_v2" "opensearch_member_outgoing_v4" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.opensearch_member.id
}

resource "openstack_networking_secgroup_rule_v2" "opensearch_member_outgoing_v6" {
  direction         = "egress"
  ethertype         = "IPv6"
  security_group_id = openstack_networking_secgroup_v2.opensearch_member.id
}

//Allow port 9200, 9300, icmp traffic from other members
resource "openstack_networking_secgroup_rule_v2" "peer_opensearch_api_access" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9200
  port_range_max    = 9200
  remote_group_id   = openstack_networking_secgroup_v2.opensearch_member.id
  security_group_id = openstack_networking_secgroup_v2.opensearch_member.id
}

resource "openstack_networking_secgroup_rule_v2" "peer_opensearch_communication_access" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9300
  port_range_max    = 9300
  remote_group_id   = openstack_networking_secgroup_v2.opensearch_member.id
  security_group_id = openstack_networking_secgroup_v2.opensearch_member.id
}

resource "openstack_networking_secgroup_rule_v2" "peer_icmp_access_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_group_id   = openstack_networking_secgroup_v2.opensearch_member.id
  security_group_id = openstack_networking_secgroup_v2.opensearch_member.id
}

resource "openstack_networking_secgroup_rule_v2" "peer_icmp_access_v6" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "ipv6-icmp"
  remote_group_id   = openstack_networking_secgroup_v2.opensearch_member.id
  security_group_id = openstack_networking_secgroup_v2.opensearch_member.id
}

//Allow port 22 and icmp traffic from the bastion
resource "openstack_networking_secgroup_rule_v2" "internal_ssh_access" {
  for_each          = { for idx, id in var.bastion_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.opensearch_member.id
}

resource "openstack_networking_secgroup_rule_v2" "bastion_icmp_access_v4" {
  for_each          = { for idx, id in var.bastion_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.opensearch_member.id
}

resource "openstack_networking_secgroup_rule_v2" "bastion_icmp_access_v6" {
  for_each          = { for idx, id in var.bastion_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "ipv6-icmp"
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.opensearch_member.id
}

//Allow port 5601, 9200 and icmp traffic from the client
resource "openstack_networking_secgroup_rule_v2" "client_opensearch_dashboard_access" {
  for_each          = { for idx, id in var.client_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5601
  port_range_max    = 5601
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.opensearch_member.id
}

resource "openstack_networking_secgroup_rule_v2" "client_opensearch_api_access" {
  for_each          = { for idx, id in var.client_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9200
  port_range_max    = 9200
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.opensearch_member.id
}

resource "openstack_networking_secgroup_rule_v2" "client_icmp_access_v4" {
  for_each          = { for idx, id in var.client_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.opensearch_member.id
}

resource "openstack_networking_secgroup_rule_v2" "client_icmp_access_v6" {
  for_each          = { for idx, id in var.client_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "ipv6-icmp"
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.opensearch_member.id
}

//Allow port 9200, 9100 and icmp traffic from metrics server
resource "openstack_networking_secgroup_rule_v2" "metrics_server_node_exporter_access" {
  for_each          = { for idx, id in var.metrics_server_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9100
  port_range_max    = 9100
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.opensearch_member.id
}

resource "openstack_networking_secgroup_rule_v2" "metrics_server_opensearch_exporter_access" {
  for_each          = { for idx, id in var.metrics_server_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9200
  port_range_max    = 9200
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.opensearch_member.id
}

resource "openstack_networking_secgroup_rule_v2" "metrics_server_icmp_access_v4" {
  for_each          = { for idx, id in var.metrics_server_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.opensearch_member.id
}

resource "openstack_networking_secgroup_rule_v2" "metrics_server_icmp_access_v6" {
  for_each          = { for idx, id in var.metrics_server_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "ipv6-icmp"
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.opensearch_member.id
}