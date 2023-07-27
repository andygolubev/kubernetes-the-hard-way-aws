resource "aws_vpc" "this" {
  cidr_block = "172.20.0.0/16"
}

output "vpc-arn" {
    value = aws_vpc.this.arn
}