terraform {
  required_version = ">= 1.4.5"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.38.2"
    }
  }
}
