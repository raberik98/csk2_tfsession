variable "aws_region" {
  type = string
  default = "eu-central-1"
}

variable "aws_profile" {
  type = string
}

variable "project_name" {
  type = string
}

variable "vpc" {
  type = object({
    name = string
    cidr_block = string
    tags = map(string)
    NAT_subnet = string

    subnets = list(object({
      name = string
      cidr_block = string
      type = string // public | private
    }))
  })
}