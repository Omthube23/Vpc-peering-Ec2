variable "name" { type = string }
variable "requester_vpc_id" { type = string }
variable "accepter_vpc_id" { type = string }
variable "requester_cidr" { type = string }
variable "accepter_cidr" { type = string }
variable "requester_route_tables" { type = map(string) }
variable "accepter_route_tables" { type = map(string) }
variable "auto_accept" {
  type    = bool
  default = true
}
variable "tags" { type = map(string) }
