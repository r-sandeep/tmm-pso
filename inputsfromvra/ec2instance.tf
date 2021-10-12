module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  name                   = "RAC-EC2"
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type_map[var.env]
  key_name               = aws_key_pair.key_pair.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [module.instance_sg.security_group_id]
  tags = merge(
  local.common_tags,
  {"Name" = element(var.instance_tags, count.index)
   "env" = "var.env"}
  )
  
}