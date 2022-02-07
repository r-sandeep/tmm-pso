variable "rg_name" {
    description = "Resource Group Name"
}

variable "rg_location" {
    description = "Resource Group Name"
}

variable "subnet" {
    description = "Subnet id"
}

variable "replicas" {
    default     = 2
    description = "Number of VM Replicas"
}

variable "asg_id" {
    description = "Application security group id"
}

variable "cluster_name" {
  description = "Cluster secret"
}

variable "bastion_ip" {
  description = "bastion_ip"
}


