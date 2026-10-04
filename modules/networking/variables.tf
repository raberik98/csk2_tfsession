variable "vpc_name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "vpc_tags" {
  type = map(string)
}

variable "project_name" {
  type = string
}

variable "subnets" {
  type = list(object({
    name       = string
    cidr_block = string
    type       = string // public | private
  }))
}

variable "NAT_subnet" {
  type = string
}
