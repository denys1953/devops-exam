variable "do_token" {
  description = "DigitalOcean API Token"
  type        = string
  sensitive   = true
}

variable "ssh_key_fingerprint" {
  description = "SSH Key Fingerprint"
  type        = string
}

variable "last_name" {
  description = "Your last name"
  type        = string
  default     = "dzhumalo"
}