variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "creator" {
    description = "Name of creator"
    type = string
    default = "Production Team"
}

variable "techstack" {
    description = "Choose your tech stack - php82, php74, java11, java8, tomcat85j11, tomcat85j8, go344, docker"
    type = string
    default = "php82"
}

variable "eb_app_name" {
    description = "Elastic beanstalk application name"
    type = string
    default = "Ebapp1_demo"
}

variable "eb_env_name" {
    description = "Elastic beanstalk environment name"
    type = string
    default = "Prod"
}

variable "app_version" {
    description = "Application version"
    type = string
    default = "1.0"
}

variable "eb_stack" {
    description = "Platform for Elastic beanstalk environment" 
    type = map(string)
    default = {
        php82 = "64bit Amazon Linux 2023 v4.0.1 running PHP 8.2"
        php74 = "64bit Amazon Linux 2 v3.3.9 running PHP 7.4"
        java11 = "64bit Amazon Linux 2 v3.2.10 running Corretto 11"
        java8 = "64bit Amazon Linux 2 v3.2.10 running Corretto 8"
        tomcat85j11 = "64bit Amazon Linux 2 v4.2.10 running Tomcat 8.5 Corretto 11"
        tomcat85j8 = "64bit Amazon Linux 2 v4.2.10 running Tomcat 8.5 Corretto 8"
        go1 = "64bit Amazon Linux 2 v3.4.4 running Go 1"
        docker = "64bit Amazon Linux 2 v3.4.10 running Docker"
    }
}