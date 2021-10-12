module "instance_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name = "ec2instance_sg"
  description = "Security Group with SSH port open for everybody"
  vpc_id = var.vpc_id
  ingress_rules = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]
  tags = merge(
  local.common_tags,
  {"Name" = "RAC SG RHEL"
   "env" = "var.env"})

  
}