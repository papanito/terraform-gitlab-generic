terraform {
  required_version = ">= 1.10.0, < 2.0.0"
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 18.0.0, < 19.0.0"
    }
  }
}
