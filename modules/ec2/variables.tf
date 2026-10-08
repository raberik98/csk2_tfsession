variable "name" { type = string }
variable "type" { type = string } // ec2 | bastion 
variable "ami" { type = string }
variable "instance_type" { type = string }
variable "key_name" { type = string }
variable "subnet_id" { type = string }
variable "vpc_id" { type = string }
variable "tags" { type = map(string) }

