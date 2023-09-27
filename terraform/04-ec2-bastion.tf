data "aws_ami" "bastion" {
  most_recent = true
  owners      = ["099720109477"]

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

}

resource "aws_instance" "bastion" {
  subnet_id                   = aws_subnet.public-subnet-0.id
  ami                         = data.aws_ami.bastion.id
  instance_type               = var.instance_type_bastion
  security_groups             = [ aws_security_group.public.id, ]
  associate_public_ip_address = true

  # lifecycle {
  #   prevent_destroy = true
  # }

  tags = {
    Name = "Bastion Host"
  }
}