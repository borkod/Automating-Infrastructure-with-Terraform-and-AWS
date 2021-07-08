terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
  alias  = "source"
}

provider "aws" {
  alias  = "dest"
  region = var.dest_region
}