variable "region" {
  description = "AWS region to deploy resources"
  type        = string
}

# -------------------------
# VPC Variables
# -------------------------
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

# -------------------------
# Public Subnets
# -------------------------
variable "public_subnets" {
  description = "Map of public subnets"

  type = map(object({
    cidr = string
    az   = string
  }))
}

# -------------------------
# Private Subnets
# -------------------------
variable "private_subnets" {
  description = "Map of private subnets"

  type = map(object({
    cidr = string
    az   = string
  }))
}
# variable "private_subnet_cidrs" {
 # type = list(string)
#}

#variable "availability_zones" {
#  type = list(string)
#}

#variable "public_subnet_cidrs" {
#  type = list(string)
#} 