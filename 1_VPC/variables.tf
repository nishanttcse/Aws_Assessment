variable "region" {
  default = "ap-south-1"
} # Mumbai; change as desired
variable "prefix" {
  description = "Resource prefix, e.g. FirstName_Lastname"
  type        = string
}
