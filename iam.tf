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

/*resource "aws_iam_policy" "rds_full_access_policy" {
  name        = "RDSFullAccessPolicy"
  description = "Policy for full access to RDS resources"

  # Define the policy document to allow full access to RDS
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "rds:*",
        Effect   = "Allow",
        Resource: ["arn:aws:rds:region:*:*"]
      },

      {

            "Effect": "Allow",

            "Action": ["rds:Describe*"],

            "Resource": ["*"]

        }

    ],

  })

}

 

resource "aws_iam_policy_attachment" "attach_rds_full_access_policy" {

    roles     = [aws_iam_role.elastic_beanstalk_ec2_role.name]

    name        = "RDSFullAccessPolicy"

  policy_arn = aws_iam_policy.rds_full_access_policy.arn

 

}*/