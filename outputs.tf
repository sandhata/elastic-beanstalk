output "dns_endpoint" {
    value = "http://${aws_elastic_beanstalk_environment.tfenvprod.endpoint_url}/"
}