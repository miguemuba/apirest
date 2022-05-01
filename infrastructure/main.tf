terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.12.1"
    }
  }
}

provider "aws" {
  region = local.region

}

locals {
  region = "eu-west-1"
}

module "api-rest-infra" {
  source                 = "./my-infra"
  vpc_name               = "${var.vpc_name}"
  alb_name               = "${var.alb_name}"
  load_balancer_type     = "${var.load_balancer_type}"
  http_tcp_listener_port = "${var.http_tcp_listener_port}"
}