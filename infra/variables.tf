variable "hcloud_token" {
  sensitive = true
}

variable "hcloud_location" {
  default = "nbg1"
}

variable "nodes_count" {
  type    = number
  default = 1
}

variable "base_image" {
  type    = string
  default = "ubuntu-22.04"
}

variable "server_type" {
  type    = string
  default = "cpx11"
}
