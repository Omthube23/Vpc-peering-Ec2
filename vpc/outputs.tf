# Expose what the root orchestrator needs
output "prod_public_subnet_id" {
  value = module.prod.public_subnet_id
}
output "dev_public_subnet_id" {
  value = module.dev.public_subnet_id
}
output "prod_sg_id" {
  value = module.prod_sg.id
}
output "dev_sg_id" {
  value = module.dev_sg.id
}
output "vpc_peering_connection_id" {
  value = module.prod_dev_peering.peering_id
}
