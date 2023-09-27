terraform {
  backend "s3" {
    #
    # Do not edit "us-east-1" value.
    # It will be replaced in the pipeline by the command: sed -i 's/us-east-1/$AWS_REGION/g' 00-provider.tf 
    #

    bucket         = "terraform-state-for-kubernetes-the-hard-way-packer2-us-east-1"
    key            = "terraform-state-for-kubernetes-the-hard-way-packer2-us-east-1/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-for-terraform-state-for-kubernetes-the-hard-way-packer-us-east-1"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}