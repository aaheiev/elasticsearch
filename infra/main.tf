locals {
  node_name_prefix = "esnode"
}

resource "hcloud_server" "nodes" {
  count                      = var.nodes_count
  name                       = "${local.node_name_prefix}-${count.index + 1}"
  image                      = var.base_image
  server_type                = var.server_type
  ignore_remote_firewall_ids = false
  keep_disk                  = false
  delete_protection          = false
  rebuild_protection         = false
  ssh_keys                   = ["hash@MyPleasure"]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

resource "local_file" "deploy_development_actions" {
  filename = "${path.module}/../inventory/infra.ini"
  content = templatefile("${path.module}/templates/elasticsearch.hosts.ini", {
    nodes = hcloud_server.nodes
  })
}
