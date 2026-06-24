terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.36.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.2.1"
    }
  }

  required_version = ">= 1.2"
}
