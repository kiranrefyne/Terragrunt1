include "root" {
    path = find_in_parent_folders()
}

terraform {
    source = "../../modules/VPC"
}

inputs = {
    
region="us-east-1"
environment="Refyne-UAT"
vpc_cidr="10.0.0.0/16"
public_subnets_cidr=["10.0.0.0/24","10.0.1.0/24","10.0.2.0/24"]
private_subnets_cidr=["10.0.3.0/24","10.0.4.0/24","10.0.5.0/24"]
availability_zones = ["data.availability_zones.available.id"]
}