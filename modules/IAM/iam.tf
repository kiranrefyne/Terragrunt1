resource "aws_iam_role" "elasticbeanstackrole" {
  name = "elasticbeanstackrole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "tag-value"
  }
}

resource "aws_iam_instance_profile" "elasticbeanstalkprofile" {
    name = "elasticbeanstalkprofile"
    role = "${aws_iam_role.elasticbeanstackrole.name}"
  
}

resource "aws_iam_role_policy" "elasticbeanstalkpolicy" {
    name = "elasticbeanstalkpolicy"
    role = "${aws_iam_role.elasticbeanstackrole.id}"

    policy = <<-EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Resource": "*",
            "Effect": "Allow"
            
        }
    ]
    }
    EOF
}


  


