terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    endpoint                    = "fra1.digitaloceanspaces.com"
    bucket                      = "dzhumalo-bucket"
    key                         = "terraform.tfstate"
    region                      = "us-east-1"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}