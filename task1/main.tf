provider "digitalocean" {
  token = var.do_token
}

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# VPC
resource "digitalocean_vpc" "vpc" {
  name     = "${var.last_name}-vpc"
  region   = "fra1"
  ip_range = "10.10.10.0/24"
}

# VM (Droplet)
resource "digitalocean_droplet" "node" {
  name     = "${var.last_name}-node"
  size     = "s-2vcpu-4gb"
  image    = "ubuntu-24-04-x64"
  region   = "fra1"
  vpc_uuid = digitalocean_vpc.vpc.id
  ssh_keys = [var.ssh_key_fingerprint]
}

# Firewall
resource "digitalocean_firewall" "fw" {
  name        = "${var.last_name}-firewall"
  droplet_ids = [digitalocean_droplet.node.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "8000-8003"
    source_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0"]
  }
}

# Spaces bucket
resource "digitalocean_spaces_bucket" "bucket" {
  name   = "${var.last_name}-bucket"
  region = "fra1"
}