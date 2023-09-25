terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.73.0"
    }
  }
}

provider "aws" {
  region = var.aws_region  
 access_key = "AKIAQWTROLOGIYBTTDMI"
 secret_key = "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"
}

