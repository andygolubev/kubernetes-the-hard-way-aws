data "amazon-ami" "ubuntu" {
  filters = {
     name = "ubuntu/images/*ubuntu-jammy-22.04-${var.arch}-server-*"
     root-device-type    = "ebs"
     virtualization-type = "hvm"
  }
  owners      = ["099720109477"]
  most_recent = true
  region      = var.region
}