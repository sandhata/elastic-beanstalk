resource "aws_elastic_beanstalk_application" "demo_ebapp1" {
  name        = var.eb_app_name
  description = "Elastic Beanstalk application with PHP through terraform "

  appversion_lifecycle {
    service_role          = aws_iam_role.elastic_beanstalk_ec2_role.arn
    max_count             = 128
    delete_source_from_s3 = true
  }
}

resource "aws_s3_bucket" "default" {
  bucket = "ebapp1prodbucket25"
}

resource "aws_s3_bucket_object" "default" {
  bucket = aws_s3_bucket.default.id
  key    = "beanstalk/php-webapp.zip"
  source = "webapp.zip"
}


resource "aws_elastic_beanstalk_application_version" "default" {
  name        = var.app_version
  application = var.eb_app_name
  description = "application version created by terraform"
  bucket      = aws_s3_bucket.default.id
  key         = aws_s3_bucket_object.default.id
}
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Demo VPC"
  }
}

data "aws_subnets" "default_subs" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

resource "aws_security_group" "ingress-all-test" {
name = "allow-all-sg"
vpc_id = "${aws_default_vpc.default.id}"
ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
  }
// Terraform removes the default rule
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "tls_private_key" "pk" { #Creates a PEM (and OpenSSH) formatted private key.
  algorithm = "RSA"  
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "LinuxVM"       # Create a "LinuxVM" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "ssh_key" {  #Generates a local file with the given content.
  filename = "${aws_key_pair.kp.key_name}.pem"
  content = tls_private_key.pk.private_key_pem
  file_permission = "0400"
}

resource "aws_elastic_beanstalk_configuration_template" "tf_template" {
  name                = "tf-prod-template-config"
  application         = aws_elastic_beanstalk_application.demo_ebapp1.name
  solution_stack_name = var.eb_stack[var.techstack]
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_default_vpc.default.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", data.aws_subnets.default_subs.ids)
  }

  setting {
      namespace = "aws:ec2:instances"
      name = "InstanceTypes"
      value = "t2.micro"
  }

  setting {
      namespace = "aws:ec2:instances"
      name = "SupportedArchitectures"
      value = "x86_64"
  }

  setting {
      namespace = "aws:autoscaling:launchconfiguration"
      name = "IamInstanceProfile"
      value = aws_iam_instance_profile.elastic_beanstalk_ec2_profile.arn
  }
    setting {
      namespace = "aws:autoscaling:launchconfiguration"
      name = "SecurityGroups"
      value = aws_security_group.ingress-all-test.id
  }
  setting {
      namespace = "aws:autoscaling:asg"
      name = "MinSize"
      value = 1
  }

  setting {
      namespace = "aws:autoscaling:asg"
      name = "MaxSize"
      value = 2
  }

  setting {
      namespace = "aws:elasticbeanstalk:environment"
      name = "EnvironmentType"
      value = "LoadBalanced"
  }

 setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "${aws_key_pair.kp.key_name}"
    resource  = ""
  }
}

resource "aws_elastic_beanstalk_environment" "tfenvprod" {
  name                = var.eb_env_name
  application         = aws_elastic_beanstalk_application.demo_ebapp1.name
  template_name = aws_elastic_beanstalk_configuration_template.tf_template.name
  version_label = var.app_version
  
}


