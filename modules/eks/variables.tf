variable "name" { type = string }
variable "subnet_ids" { type = list(string) }
variable "vpc_id" { type = string }
variable "aws_profile" { type = string }
variable "aws_region" { type = string }
variable "k8s_version" { type = string }

# variable "node_groups" {
#   type = list(object({
#     name = string

#   }))
# }

variable "configure_kubectl" {
  type = object({
    aws_region      = string
    aws_cli_profile = string
  })
}

variable "node_groups" {
  type = list(object({
    name       = string
    subnet_ids = list(string)

    labels = optional(map(string), {})
  }))
}
