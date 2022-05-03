# Terraform Module
This module creates an App infrastructure building and configuring this resources in ``AWS Provider``:
- Application Load Balancer with HTTP listener
- VPC, 2 private subnets, 2 public subnets
- Security group to allow traffic on port 80

## Initialize module
```bash
terraform init
```

## Planning of infra
```bash
terraform plan -var-file=test.tfvars
```
``main`` file calls the module and passes the input variables.
