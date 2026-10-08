variable "aws_region" {
  type = string
  default = "eu-central-1"
}

variable "aws_profile" { type = string }
variable "project_name" { type = string }

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

variable "keys" {
  type = list(object({
    name = string
    key_path = string
    public_key_string = string
  }))
}


variable "instances" {
  type = list(object({
    name          = string
    type          = string # ec2 | bastion
    ami           = string
    instance_type = string
    key_name      = string
    subnet_name     = string
    tags          = map(string)
  }))

  validation {
    condition = alltrue([
      for i in var.instances:
        contains(["ec2", "bastion"], i.type)
    ]) 
    error_message = "type must be either 'ec2' or 'bastion'."
  }
}