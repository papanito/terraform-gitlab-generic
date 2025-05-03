terraform {
  required_version = ">= 1.10.0, < 2.0.0"
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 17.0.0, < 18.0.0"
    }
  }
}
