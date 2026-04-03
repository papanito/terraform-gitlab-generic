terraform {
  required_version = ">= 1.10.0, < 2.0.0"

  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 18.0"
    }
  }
}

variable "gitlab_token" {
  type      = string
  sensitive = true
}

provider "gitlab" {
  base_url         = "https://gitlab.com/"
  early_auth_check = false
  token            = var.gitlab_token
}
