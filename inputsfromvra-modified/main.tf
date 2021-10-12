inputs:
  vpc_id:
    type: string
    default: vpc-03591eb59452ad637
    description: VPC ID of exist VPC
  subnet_id:
    type: string
    default: subnet-0d305529ce7e26c09
    description: SubnetId of exist VPC
  ami:
    type: string
    default: ami-0b0af3577fe5e3532
    description: ami ids
  instance_count:
    type: number
    default: 2
    description: instance_count
  instance_type_map:
    type: object
    default:
      qa: t2.small
      prod: t2.large
      dev: t2.micro
    description: EC2 Instance Type
  aws_region:
    type: string
    default: us-east-1
    description: Region in which AWS Resources to be created
  env:
    type: string
    default: dev
    description: choose which environment to deploy
  instance_tags:
    type: array
    default:
      - mysql
      - apache
resources:
  terraform:
    type: Cloud.Terraform.Configuration
    properties:
      variables:
        vpc_id: '${input.vpc_id}'
        subnet_id: '${input.subnet_id}'
        ami: '${input.ami}'
        instance_count: '${input.instance_count}'
        instance_type_map: '${input.instance_type_map}'
        aws_region: '${input.aws_region}'
        env: '${input.env}'
        instance_tags: '${input.instance_tags}'
      providers:
        - name: aws
          # List of available cloud zones: AWS-Sandbox-01/us-east-1
          cloudZone: AWS-Sandbox-01/us-east-1
      terraformVersion: 1.0.7
      configurationSource:
        repositoryId: cbc35f35-148a-4590-aadd-c76db9e03e07
        commitId: 691e2326aab87e46c3848b74bb7ca56ac387c581
        sourceDirectory: Demo
