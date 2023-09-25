terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.73.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"  
 access_key = "AKIAQWTROLOGIYBTTDMI"
 secret_key = "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"
}

resource "aws_db_instance" "default" {
allocated_storage = 20
identifier = "prodinstance"
storage_type = "gp2"
engine = "mysql"
engine_version = "5.7"
instance_class = "db.t3.micro"
name = "proddb"
username = "admin"
password = "Admin54132"
parameter_group_name = "default.mysql5.7"
skip_final_snapshot  = true
final_snapshot_identifier  = true
publicly_accessible = true
#security_group_names = [aws_security_group.ingress-all-test.name]
}