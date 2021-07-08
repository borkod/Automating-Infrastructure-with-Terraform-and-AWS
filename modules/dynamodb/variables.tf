variable "destRegion" {
 type = string 
}

variable "destBucketName" {
  type = string
}

variable "destBucketArn" {
  type = string
}

variable "backupFileName" {
  type = string
}

variable "destKmsArn" {
  type = string
}

variable "region" {
    type = string
    default = "us-east-1"
}

variable "dest_region" {
    type = string
    default = "us-west-2"
}

variable "destProviderAlias" {
  type = string
  default = "aws.dest"
}