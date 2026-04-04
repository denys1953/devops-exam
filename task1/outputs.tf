output "droplet_ip" {
  value = digitalocean_droplet.node.ipv4_address
}

output "vpc_id" {
  value = digitalocean_vpc.vpc.id
}

output "bucket_name" {
  value = digitalocean_spaces_bucket.bucket.name
}