output "public_subnet_ids" {
  value = aws_subnet.public-subnet[0]
  description = "List of IDs of public subnets"
}
