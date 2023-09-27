// ssh-keygen -t ed25519 -b 4096 -C "account@gmail.com" -N "" -f output_file_name

resource "aws_key_pair" "bastion-key" {
  key_name   = "b-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJser924mq9JcdE6ef1IpvSXyAUUzKuDCL+FYZhDaPl8 account@gmail.com"
}