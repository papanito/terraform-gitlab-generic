locals {
  repositories = {
    infrastructure = {
      description  = "My personal repo"
      access_level = "private-infrastructure"
      gitlab = {
      }
      topics = [
        "infrastructure"
      ]
    }
    clawfinger = {
      description  = "My personal repo"
      access_level = "minimal-public"
      gitlab = {
      }
      topics = [
        "gitlab"
      ]
    }
    "gitlab-profile" = {
      name         = "Gitlab Profile for clawfinger"
      description  = "Profile Repo"
      access_level = "private-build"
      gitlab = {
        group_name     = "clawfinger-test"
        approval_rules = local.approval_rules["allow_force_push"]
      }
      topics = [
        "profile",
        "gitlab"
      ]
    }
  }
}

locals {
  approval_rules = {
    "minimal" = {
      "default-branches" = {
        approvals_required = 1
        users              = ["clawfinger"]
        protected_branches = ["main"]
      }
    }
    "allow_force_push" = {
      "default-branches" = {
        approvals_required     = 1
        users                  = ["clawfinger"]
        protected_branches     = ["main"]
        allow_force_push       = true
        unprotect_access_level = "admin"
      }
    }
  }
}

import {
  to = module.gitlab.gitlab_group.groups["clawfinger-test"]
  id = 128938890
}
