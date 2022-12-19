variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-west-2"
}

variable "aws_vpc_cidr_block" {
  description = "CIDR block for vpc"
  default     = "10.0.0.0/16"
}

variable "aws_cidr_block_subnet_public_1" {
  description = "CIDR block for vpc public subnet 1"
  default     = "10.0.4.0/24"
}

variable "aws_cidr_block_subnet_public_2" {
  description = "CIDR block for vpc public subnet 2"
  default     = "10.0.5.0/24"
}

variable "aws_cidr_block_subnet_public_3" {
  description = "CIDR block for vpc public subnet 3"
  default     = "10.0.6.0/24"
}

variable "aws_cidr_block_subnet_private_1" {
  description = "CIDR block for vpc private subnet 1"
  default     = "10.0.1.0/24"
}

variable "aws_cidr_block_subnet_private_2" {
  description = "CIDR block for vpc private subnet 2"
  default     = "10.0.2.0/24"
}

variable "aws_cidr_block_subnet_private_3" {
  description = "CIDR block for vpc private subnet 3"
  default     = "10.0.3.0/24"
}

