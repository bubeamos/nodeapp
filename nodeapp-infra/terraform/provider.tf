# provider.tf

# Specify the provider and access details
provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "default"
  region                  = var.aws_region
}
# Remote Backend 
 module "terraform_state_backend" {
   source        = "git::https://github.com/cloudposse/terraform-aws-tfstate-backend.git?ref=tags/0.9.0"
   namespace     = var.namespace
   stage         = var.stage 
   name          = "terraform"
   attributes    = ["state"]
   region        = var.aws_region 
 }

