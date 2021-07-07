terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
      configuration_aliases = [ aws.usw ]
    }
  }
}

provider "aws" {
  alias  = "usw"
  region = "us-west-1"
}