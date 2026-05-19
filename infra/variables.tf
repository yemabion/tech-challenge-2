variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "techchallenge2"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "frontend_container_port" {
  type    = number
  default = 80
}

variable "backend_container_port" {
  type    = number
  default = 8080
}

variable "frontend_image_tag" {
  type    = string
  default = "latest"
}

variable "backend_image_tag" {
  type    = string
  default = "latest"
}