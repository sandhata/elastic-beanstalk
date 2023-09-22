resource "aws_iam_role" "elastic_beanstalk_ec2_role" {
  name = "elastic_beanstalk_ec2_role_demo"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    created-by = var.creator
  }
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_ec2_role_policy"{
  role = aws_iam_role.elastic_beanstalk_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
 }

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_ec2_role_policy1"{
  role = aws_iam_role.elastic_beanstalk_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_instance_profile" "elastic_beanstalk_ec2_profile" {
  name = "prod_profile"
  role = aws_iam_role.elastic_beanstalk_ec2_role.name
}
