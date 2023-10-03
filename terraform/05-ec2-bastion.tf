# data "aws_ami" "bastion" {
#   most_recent = true
#   owners      = ["099720109477"]

#     filter {
#         name   = "name"
#         values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#     }

#     filter {
#         name = "virtualization-type"
#         values = ["hvm"]
#     }

# }

data "aws_ami" "k8s-bastion-host-ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["k8s-bastion-host*"]
  }
}

resource "aws_instance" "bastion" {
  subnet_id                   = aws_subnet.public-subnet-0.id
  ami                         = data.aws_ami.k8s-bastion-host-ami.id
  instance_type               = var.instance_type_bastion
  security_groups             = [ aws_security_group.public.id, ]
  associate_public_ip_address = true

  key_name      = aws_key_pair.bastion-key.key_name

  # lifecycle {
  #   prevent_destroy = true
  # }

  tags = {
    Name = "Bastion Host"
  }
}


# resource "aws_instance" "my_ec2" 
#   ami                    = "ami-0e742cca61fb65051"
#   instance_type          = "t2.micro"
#   key_name               = "tf_provisioner"
#   vpc_security_group_ids = [aws_security_group.allow_ssh.id]


#   # Connect with AWS Resoeces
#   connection {
#     type        = "ssh"
#     user        = "ec2-user"
#     host        = self.public_ip
#     private_key = file("./tf_provisioner.pem")
#   }


#   # Remote Provisioner for User Data
#   provisioner "remote-exec" {
#     inline = [
#       "sudo yum install -y httpd.x86_64",
#       "sudo systemctl start httpd.service",
#       "sudo  systemctl enable httpd.service",
#       "sudo chmod -R 777 /var/www/html",
#       "sudo  echo “User Data Installed by Terraform $(hostname -f)” >> /var/www/html/index.html"
#     ]
#   }

#  tags = {
#     Name = "Remote_Provisioner"
#   }
# }







