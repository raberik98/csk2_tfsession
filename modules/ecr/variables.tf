variable "repository_name" { type = string }
variable "region" { type = string }

variable "scan_on_push" {
  type    = bool
  default = true
}

variable "profile" {
  type    = string
  default = "default"
}

variable "image_tag" {
  description = "Tag applied to the image (e.g. \"1.0\")."
  type        = string
}

variable "image_path" {
  description = "Build context. If empty, an existing local image '<repository_name>:<image_tag>' is pushed as-is."
  type        = string
  default     = ""
}
