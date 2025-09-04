variable "region" {
  type    = string
  default = "us-east-1"
}

variable "tags" {
  type = map(string)
  default = {
    Project = "Two-VPC-Peering-Demo"
    Owner   = "Omthube23"
  }
}
