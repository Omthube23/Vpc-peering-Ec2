variable "name" { type = string }
variable "subnet_id" { type = string }
variable "security_group_ids" { type = list(string) }

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "Omk1"
}

variable "tags" { type = map(string) }
