# EC2 instanca za Backend
resource "aws_instance" "backend" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  
  subnet_id                   = aws_subnet.public[1].id
  vpc_security_group_ids      = [aws_security_group.backend.id]
  associate_public_ip_address = true
  
  key_name = var.key_name != "" ? var.key_name : null
  
  user_data = templatefile("${path.module}/user-data/backend.sh", {
    github_repo   = var.github_repo
    db_host       = aws_db_instance.main.address
    db_port       = aws_db_instance.main.port
    db_name       = var.db_name
    db_username   = var.db_username
    db_password   = var.db_password
  })
  
  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }
  
  tags = {
    Name = "${var.project_name}-backend"
    Type = "backend"
  }
  
  depends_on = [aws_db_instance.main]
}
