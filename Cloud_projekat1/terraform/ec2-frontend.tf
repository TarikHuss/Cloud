# EC2 instanca za Frontend
resource "aws_instance" "frontend" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.frontend.id]
  associate_public_ip_address = true
  
  key_name = var.key_name != "" ? var.key_name : null
  
  user_data = templatefile("${path.module}/user-data/frontend.sh", {
    github_repo = var.github_repo
    backend_url = "http://${aws_lb.main.dns_name}/api"
  })
  
  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }
  
  tags = {
    Name = "${var.project_name}-frontend"
    Type = "frontend"
  }
  
  depends_on = [aws_db_instance.main]
}
