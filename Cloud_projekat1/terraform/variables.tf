variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Ime projekta"
  type        = string
  default     = "flask-vue-books"
}

variable "github_repo" {
  description = "GitHub repozitorij URL"
  type        = string
}

variable "db_name" {
  description = "Ime baze podataka"
  type        = string
  default     = "books"
}

variable "db_username" {
  description = "Username za bazu podataka"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Password za bazu podataka"
  type        = string
  sensitive   = true
  default     = "postgres123!"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Ime EC2 key pair-a"
  type        = string
  default     = ""
}

variable "allowed_ips" {
  description = "Lista IP adresa koje mogu pristupiti aplikaciji"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
