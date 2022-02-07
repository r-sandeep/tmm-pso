
provider "azurerm" {
  client_id = "f615d474-fa83-4f7b-9eca-2bc4977ac7be"
  subscription_id = "ccb5147f-8cad-4659-b0bf-099d9d11109e"
  tenant_id = "CC4BAF00-15C9-48DD-9F59-88C98BDE2BE7"
  client_secret = "${var.secret}"
  version = "=1.30.1"
}

module "rg" {
  source = "./rg"
  resource_group_name = "${var.resource_group_name}"
  resource_group_location = "${var.resource_group_location}"
}

module "lb" {
  source = "./lb"
  rg_name = "${module.rg.name}"
  rg_location = "${module.rg.location}" 
}

module "asg" {
  source = "./application-security"
  rg_name = "${module.rg.name}"
  rg_location = "${module.rg.location}" 
  cluster_name = "${var.cluster_name}"
}

module "storage" {
  source = "./storage"
  rg_name = "${module.rg.name}"
  rg_location = "${module.rg.location}" 
  subnet      = "${var.subnet_id}"
  name = "${var.storage_name}"
}

module "master" {
  source = "./master"
  rg_name = "${module.rg.name}"
  rg_location = "${module.rg.location}" 
  subnet      = "${var.subnet_id}"
  asg_id = "${module.asg.asg_id}"
  lb_id = "${module.lb.id_lbapi}"
  replicas = "${var.master_size}"
  cluster_name = "${var.cluster_name}"
  bastion_ip = "${var.bastion_ip}"
}

module "infra" {
  source = "./infra"
  rg_name = "${module.rg.name}"
  rg_location = "${module.rg.location}"
  subnet      = "${var.subnet_id}"
  asg_id = "${module.asg.asg_id}"
  lb_id = "${module.lb.id_lbrouter}"
  replicas = "${var.infra_size}"
  cluster_name = "${var.cluster_name}"
  bastion_ip = "${var.bastion_ip}"
}

module "node" {
  source = "./node"
  rg_name = "${module.rg.name}"
  rg_location = "${module.rg.location}"
  subnet      = "${var.subnet_id}"
  asg_id = "${module.asg.asg_id}"
  replicas = "${var.node_size}"
  cluster_name = "${var.cluster_name}"
  bastion_ip = "${var.bastion_ip}"
}
/* DONE */


/* variables */
variable "subnet_id" {
   default = "/subscriptions/fbf7e6d4-cf46-4b1b-a1a3-17c98dd81fd8/resourceGroups/RSGNETT001/providers/Microsoft.Network/virtualNetworks/DCVNETWT001/subnets/DC_IAAS_POC"
}

variable "resource_group_name" {}

variable "resource_group_location" {
  default = "westeurope"
}

variable "storage_name" {
    description = "Storage Account Name"
}

variable "master_size" {
    default = 1
    description = "Number of maters vm"  
}

variable "infra_size" {
    default = 1
    description = "Number of infras vm"  
}

variable "node_size" {
    default = 2
    description = "Number of nodes vm"  
}

variable "master_lb_id" {
  description = "Reference to load master loadbalancer backend address pool"
}

variable "infra_lb_id" {
  description = "Reference to load master loadbalancer backend address pool"
}

variable "secret" {
  description = "Client secret"
}

variable "cluster_name" {
  description = "Cluster secret"
}

variable "bastion_ip" {
  default = "10.244.253.111"
}





