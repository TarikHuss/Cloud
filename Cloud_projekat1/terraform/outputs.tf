output "alb_dns_name" {
  description = "DNS ime Application Load Balancer-a"
  value       = aws_lb.main.dns_name
}

output "application_url" {
  description = "URL aplikacije"
  value       = "http://${aws_lb.main.dns_name}"
}

output "frontend_instance_id" {
  description = "ID Frontend EC2 instance"
  value       = aws_instance.frontend.id
}

output "backend_instance_id" {
  description = "ID Backend EC2 instance"
  value       = aws_instance.backend.id
}

output "frontend_public_ip" {
  description = "Public IP Frontend instance"
  value       = aws_instance.frontend.public_ip
}

output "backend_public_ip" {
  description = "Public IP Backend instance"
  value       = aws_instance.backend.public_ip
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.main.endpoint
}

output "rds_database_name" {
  description = "Ime RDS baze podataka"
  value       = aws_db_instance.main.db_name
}
