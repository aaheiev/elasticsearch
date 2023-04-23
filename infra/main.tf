locals {
  node_name_prefix = "esnode"
}

resource "hcloud_server" "elasticsearch_nodes" {
  count                      = var.nodes_count
  name                       = "${local.node_name_prefix}-${count.index + 1}"
  image                      = var.base_image
  server_type                = var.server_type
  ignore_remote_firewall_ids = false
  keep_disk                  = false
  delete_protection          = false
  rebuild_protection         = false
  location                   = var.hcloud_location
  ssh_keys                   = ["hash@MyPleasure"]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  labels = {
    elasticsearch = ""
  }
}

resource "hcloud_load_balancer" "elasticsearch_balancer" {
  name               = "elasticsearch-load-balancer"
  load_balancer_type = "lb11"
  location           = var.hcloud_location
}

resource "hcloud_load_balancer_target" "elasticsearch_balancer_target" {
  type             = "label_selector"
  load_balancer_id = hcloud_load_balancer.elasticsearch_balancer.id
  label_selector   = "elasticsearch"
}

resource "hcloud_load_balancer_service" "elasticsearch_balancer_service" {
  load_balancer_id = hcloud_load_balancer.elasticsearch_balancer.id
  protocol         = "http"
  listen_port      = 9200
  destination_port = 9200
}

resource "local_file" "elasticsearch_ansible_inventory" {
  filename = "${path.module}/../inventory/infra.ini"
  content = templatefile("${path.module}/templates/elasticsearch.hosts.ini", {
    nodes = hcloud_server.elasticsearch_nodes
  })
}

output "elasticsearch_ip" {
  value = hcloud_load_balancer.elasticsearch_balancer.ipv4
}
