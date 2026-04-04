terraform {
  backend "s3" {
    bucket = "dzhumalo-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"

    endpoints = {
      s3 = "https://fra1.digitaloceanspaces.com"
    }

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    force_path_style            = true
  }
}