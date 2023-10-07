variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "availability_zone_names" {
  type    = list(string)
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]

  validation {
    condition     = length(var.availability_zone_names) == 3
    error_message = "You must specify 3 availability zones"
  }
}

variable "instance_type_control_plane" {
  type    = string
  default = "t2.micro"
}

variable "instance_type_working_node" {
  type    = string
  default = "t2.small"
}

variable "instance_type_load_balancer" {
  type    = string
  default = "t2.micro"
}

variable "instance_type_bastion" {
  type    = string
  default = "t2.micro"
}