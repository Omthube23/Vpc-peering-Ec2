resource "aws_vpc_peering_connection" "this" {
  vpc_id      = var.requester_vpc_id
  peer_vpc_id = var.accepter_vpc_id
  auto_accept = var.auto_accept
  tags        = merge(var.tags, { Name = var.name })
}

# Routes in requester RTs to accepter CIDR
resource "aws_route" "requester_to_accepter" {
  for_each = var.requester_route_tables

  route_table_id            = each.value
  destination_cidr_block    = var.accepter_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

# Routes in accepter RTs to requester CIDR
resource "aws_route" "accepter_to_requester" {
  for_each = var.accepter_route_tables

  route_table_id            = each.value
  destination_cidr_block    = var.requester_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}
