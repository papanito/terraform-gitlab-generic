locals {
  acl = {
    "private-mirror" = {
      "gitlab" = {
        forking          = "enabled"
        issues           = "enabled"
        pages            = "public"
        repository       = "enabled"
        visibility_level = "private"
      }
      github = {
        private         = true
        visibility      = "private"
        has_issues      = false
        has_discussions = false
        has_projects    = false
        has_wiki        = false
        is_template     = false
      }
    }
    "minimal-public" = {
      "gitlab" = {
        overall                 = "disabled"
        analytics               = "enabled"
        forking                 = "enabled"
        issues                  = "enabled"
        merge_requests          = "enabled"
        monitor                 = "enabled"
        pages                   = "public"
        repository              = "enabled"
        security_and_compliance = "enabled"
        visibility_level        = "public"
      }
      github = {
        private         = false
        visibility      = "public"
        has_issues      = true
        has_discussions = false
        has_projects    = false
        has_wiki        = false
        is_template     = false
      }
    }
    "public-build" = {
      "gitlab" = {
        overall                 = "disabled"
        analytics               = "enabled"
        builds                  = "enabled"
        container_registry      = "enabled"
        feature_flags           = "enabled"
        forking                 = "enabled"
        issues                  = "enabled"
        merge_requests          = "enabled"
        monitor                 = "enabled"
        packages                = "enabled"
        pages                   = "public"
        releases                = "enabled"
        repository              = "enabled"
        requirements            = "enabled"
        security_and_compliance = "enabled"
        visibility_level        = "public"
      }
      github = {
        private         = false
        visibility      = "public"
        has_issues      = true
        has_discussions = false
        has_projects    = false
        has_wiki        = false
        is_template     = false
      }
    }
    "minimal-private" = {
      "gitlab" = {
        overall            = "private"
        builds             = "disabled"
        container_registry = "disabled"
        environments       = "disabled"
        feature_flags      = "disabled"
        infrastructure     = "disabled"
        packages           = "disabled"
        releases           = "disabled"
        requirements       = "disabled"
        snippets           = "disabled"
        wiki               = "disabled"
      }
      github = {
        private         = true
        visibility      = "private"
        has_issues      = true
        has_discussions = false
        has_projects    = false
        has_wiki        = false
        is_template     = false
      }
    }
    "private-build" = {
      "gitlab" = {
        overall        = "private"
        environments   = "disabled"
        infrastructure = "disabled"
        snippets       = "disabled"
        wiki           = "disabled"
      }
      github = {
        private         = true
        visibility      = "private"
        has_issues      = true
        has_discussions = false
        has_projects    = false
        has_wiki        = false
        is_template     = false
      }
    }
    "private-pages" = {
      "gitlab" = {
        overall        = "private"
        environments   = "disabled"
        infrastructure = "disabled"
        pages          = "public"
        snippets       = "disabled"
        wiki           = "disabled"
      }
      github = {
        private         = true
        visibility      = "private"
        has_issues      = true
        has_discussions = false
        has_projects    = false
        has_wiki        = false
        is_template     = false
      }
    }
    "private-infrastructure" = {
      "gitlab" = {
        overall        = "private"
        feature_flags  = "disabled"
        issues         = "disabled"
        merge_requests = "disabled"
        packages       = "disabled"
        releases       = "disabled"
        snippets       = "disabled"
        wiki           = "disabled"
      }
      github = {
        private         = true
        visibility      = "private"
        has_issues      = true
        has_discussions = false
        has_projects    = false
        has_wiki        = false
        is_template     = false
      }
    }
  }
}
