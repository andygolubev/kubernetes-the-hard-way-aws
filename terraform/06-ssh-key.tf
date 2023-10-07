resource "aws_key_pair" "bastion-key" {
  key_name   = "b-key"
  public_key = file("/tmp/kthw-certs/bastion-key.pub")
}


