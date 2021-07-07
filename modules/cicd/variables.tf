variable "region" {
    type = string
    default = "us-east-1"
}

variable "sourceS3BucketArn" {
    type = string
}

variable "repo_name" {
    type = string
    default = "webserver"
}

variable "ecsClusterName" {
    type = string
    default = "live-project-ecs-cluster"
}
variable "ecsServiceName" {
    type = string
    default = "liveproject-ecs"
}

variable "ListenerArn" {
    type = string
}

variable "TG1" {
    type = string
}
variable "TG2" {
    type = string
}

variable "ecsTaskRoleArn" {
    type = string
}

variable "ecsServiceRoleArn" {
    type = string
}

variable "ecsServiceArn" {
    type = string
}
