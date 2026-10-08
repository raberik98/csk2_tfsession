variable "keys" {
  description = "Assymmetric public keys for ssh access primarily."
  default = []

  type = list(object({
    name = string
    key_path = string
    public_key_string = string
  }))


  validation {
    condition = alltrue([
        for key in var.keys :
        ( key.key_path != null && key.key_path != "" && try(file(key.key_path), "") != "" ) != ( key.public_key_string != null && key.public_key_string != "" )
    ])


    error_message = "Each key must specify either the key path or the key content as a string!"
  }
}
