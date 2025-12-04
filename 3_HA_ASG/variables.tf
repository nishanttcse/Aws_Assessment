variable "region" {
  default = "ap-south-1"
}

variable "prefix" {
  type = string
}

variable "public_subnet_ids" {
  type    = list(string)
  default = ["subnet-0245a209a2e65d3c6", "subnet-030d33eed5a60e6c1"]  
}

variable "private_subnet_ids" {
  type    = list(string)
  default = ["subnet-0e84cd327cb7d7772", "subnet-0776ba0692f3d7dda"]  
}

variable "my_ip_cidr" {
  type    = string
  default = "103.120.30.50/32"  
}
