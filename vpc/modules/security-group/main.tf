resource "aws_security_group" "this" {
  name        = var.name
  description = "SSH open to world; ICMP from peer"
  vpc_id      = var.vpc_id

  # SSH from anywhere (IPv4)
  ingress {
    description = "SSH from anywhere"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ICMP (all types/codes) only from allowed CIDRs (peer VPC)
  dynamic "ingress" {
    for_each = var.allowed_cidrs
    content {
      description = "ICMP from ${ingress.value}"
      protocol    = "icmp"
      from_port   = -1
      to_port     = -1
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    description = "Allow all outbound"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = var.name })
}
