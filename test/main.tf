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
        group_name = "clawfinger-test"
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
  }
}

import {
  to = module.gitlab.gitlab_group.groups["clawfinger-test"]
  id = 128938890
}
