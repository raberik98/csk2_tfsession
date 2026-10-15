variable "name" { type = string }
variable "subnet_ids" { type = list(string) }
variable "vpc_id" { type = string }
variable "k8s_version" { type = string }




variable "configure_kubectl" { 
    type = object({
        aws_region = string
        aws_cli_profile = string
    })
 }
