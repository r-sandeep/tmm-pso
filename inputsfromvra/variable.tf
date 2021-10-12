variable "vpc_id" {
  description = "VPC ID of exist VPC"
  type = string
  default = "vpc-03591eb59452ad637"
}


variable "subnet_id" {
  description = "SubnetId of exist VPC"
  type = string
  default = "subnet-0d305529ce7e26c09"
}

variable "ami" {
  description = "ami ids"
  type = string
  default = "ami-0b0af3577fe5e3532"
    
}

variable "instance_count" {
  description = "instance_count"
  type = number
  default = 2
    
}

variable "instance_type_map" {
  description = "EC2 Instance Type"
  type = map(string)
  default = {
    "dev" = "t2.micro"
    "qa" = "t2.small"
    "prod" = "t2.large"
  }
}

variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "us-east-1"
}

variable "env" {
  description = "choose which environment to deploy"
  type = string
  default = "dev"
}

variable "instance_tags" {
  type = list
  default = ["mysql", "apache"]
}


