module "vpc" {
  source = ".//modules/vpc/"

  name = "my-vpc"
  cidr = "172.16.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  private_subnets  = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24", "172.16.8.0/24", "172.16.9.0/24", "172.16.10.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true

  map_public_ip_on_launch = true

  tags = {
    Terraform = "true"
    Project = "liveProject"
  }
}


