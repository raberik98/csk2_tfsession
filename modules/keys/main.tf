locals {
  keys = {
    for key in var.keys :
      key.name => try(file(key.key_path) , key.public_key_string)
  }
}


resource "aws_key_pair" "this" {
  for_each = local.keys

  key_name   = each.key
  public_key = each.value
}