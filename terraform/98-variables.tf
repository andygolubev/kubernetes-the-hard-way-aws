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