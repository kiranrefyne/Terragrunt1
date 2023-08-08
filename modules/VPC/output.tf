# Output variables for VPC Module
output "vpc_id" {
  value = "${aws_vpc.Refyne-UAT-VPC.id}"
}

output "public_subnet_ids" {
  value = "${aws_subnet.Refyne-UAT-public-subnet.*.id}"
}

output "private_subnet_ids" {
  value = "${aws_subnet.Refyne-UAT-private-subnet.*.id}"
}