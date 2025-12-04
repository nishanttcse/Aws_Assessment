variable "region" { default = "ap-south-1" }

variable "prefix" {
  type = string
}

variable "public_subnet_id" {
  type = string
  default = "subnet-0e84cd327cb7d7772"  # <-- replace with your real subnet
}

variable "my_ip_cidr" {
  type = string
  default = "103.120.30.50/32"         # e.g. 103.56.112.45/32
}
