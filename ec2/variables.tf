variable "app-layer-ami" {
  description = "App Layer EC2 instance AMI"
  type        = string
  default     = "ami-0ab4d1e9cf9a1215a"
}

variable "app-layer-type" {
  description = "App Layer EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "app-layer-key" {
  description = "App Layer EC2 instance key name"
  type        = string
  default     = "book-review"
}

variable "bastion-ami" {
  description = "App Layer EC2 instance AMI"
  type        = string
  default     = "ami-0ab4d1e9cf9a1215a"
}

variable "bastion-type" {
  description = "App Layer EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "bastion-key" {
  description = "App Layer EC2 instance key name"
  type        = string
  default     = "book-review"
}

variable "vpc-name" {
    description = "Name of VPC"
    type        = string
    default     = "my-vpc"
}

