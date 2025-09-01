variable "tags" {
  type = map(string)
  default = {}
}

# PROD
variable "prod_vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "prod_public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}
variable "prod_private_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

# DEV
variable "dev_vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}
variable "dev_public_subnet_cidr" {
  type    = string
  default = "10.1.1.0/24"
}
variable "dev_private_subnet_cidr" {
  type    = string
  default = "10.1.2.0/24"
}
