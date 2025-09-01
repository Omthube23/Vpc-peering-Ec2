variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "tags" {
  type = map(string)
  default = {
    Project = "Two-VPC-Peering-Demo"
    Owner   = "Shubham"
  }
}
