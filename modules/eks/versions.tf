terraform {
  required_version = ">= 1.3.2"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.27"
    }
    # http = {
    #   source  = "hashicorp/http"
    #   version = "~> 3.4"
    # }
  }
}