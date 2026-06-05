variable "region" {
  description = "default region"
  type = string
  default = "eu-region-1"
}

variable "cidr" {
  description = "VPC CIDR"
  type = string
  default = "10.0.0.0/16"
}

variable "tags" {
  description = "Global tags to apply all resources"

  type = map(string)
  default = {
    "Terraform" = "true"
  }
}

variable "newbits" {
  description = "newbits to add cidr subnet"
  type = number
  default = 8
}