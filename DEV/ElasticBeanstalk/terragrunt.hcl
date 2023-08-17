include {
    path = find_in_parent_folders()
}

terraform {
    source = "../../modules//ElasticBeanstalk"
}

inputs = {

Application-Name = "Refyne-UAT-EB-Application"
Environment = "Refyne-UAT-EB-Environment"
Solution-Stack-Name = "64bit Amazon Linux 2 v3.5.5 running Python 3.7"
tier = "WebServer"
Public-Subnets = ["subnet-0ec59841782e7f297", "subnet-0fc1b52e775eb1512"]
Elb-Public-Subnets = ["subnet-0ec59841782e7f297", "subnet-0fc1b52e775eb1512"]
vpc_id = "vpc-0e306e6d3d4573ed3"
region = "us-east-1"
}


