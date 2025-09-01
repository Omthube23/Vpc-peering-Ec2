resource "aws_instance" "this" {
  ami                         = "ami-02d26659fd82cf299" # Ubuntu AMI
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = merge(var.tags, { Name = var.name })
}
