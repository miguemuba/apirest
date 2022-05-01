
################################################################################
# security_group Module
################################################################################

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "sg-01"
  description = "Security group"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
  }
}

################################################################################
# ALB Module
################################################################################

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = var.alb_name

  load_balancer_type = var.load_balancer_type
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = module.security_group.security_group_id

  access_logs = {
    bucket = "my-alb-logs"
  }

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = "i-0123456789abcdefg"
          port      = 80
        },
        {
          target_id = "i-a1b2c3d4e5f6g7h8i"
          port      = 8080
        }
      ]
    }
  ]

  http_tcp_listeners = [
    {
      port               = var.http_tcp_listener_port
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Hola FzSports!"
        status_code  = "200"
      }
    }
  ]


  depends_on = [
    module.security_group,
    module.vpc
  ]
}