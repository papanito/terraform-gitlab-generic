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
        builds                  = "disabled"
        container_registry      = "disabled"
        environments            = "disabled"
        feature_flags           = "disabled"
        forking                 = "enabled"
        infrastructure          = "disabled"
        issues                  = "enabled"
        merge_requests          = "enabled"
        monitor                 = "enabled"
        packages                = "disabled"
        pages                   = "public"
        releases                = "disabled"
        repository              = "enabled"
        requirements            = "disabled"
        snippets                = "disabled"
        security_and_compliance = "enabled"
        visibility_level        = "public"
        wiki                    = "disabled"
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
        environments            = "disabled"
        feature_flags           = "enabled"
        forking                 = "enabled"
        infrastructure          = "disabled"
        issues                  = "enabled"
        merge_requests          = "enabled"
        monitor                 = "enabled"
        packages                = "enabled"
        pages                   = "public"
        releases                = "enabled"
        repository              = "enabled"
        requirements            = "enabled"
        snippets                = "disabled"
        security_and_compliance = "enabled"
        visibility_level        = "public"
        wiki                    = "disabled"
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
        overall                 = "private"
        analytics               = "enabled"
        builds                  = "disabled"
        container_registry      = "disabled"
        environments            = "disabled"
        feature_flags           = "disabled"
        forking                 = "private"
        infrastructure          = "disabled"
        issues                  = "private"
        merge_requests          = "private"
        monitor                 = "private"
        packages                = "disabled"
        pages                   = "private"
        releases                = "disabled"
        repository              = "private"
        requirements            = "disabled"
        snippets                = "disabled"
        security_and_compliance = "private"
        visibility_level        = "private"
        wiki                    = "disabled"
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
        overall                 = "private"
        analytics               = "enabled"
        builds                  = "private"
        container_registry      = "private"
        environments            = "disabled"
        feature_flags           = "private"
        forking                 = "private"
        infrastructure          = "disabled"
        issues                  = "private"
        merge_requests          = "private"
        monitor                 = "private"
        packages                = "private"
        pages                   = "private"
        releases                = "private"
        repository              = "private"
        requirements            = "private"
        snippets                = "disabled"
        security_and_compliance = "private"
        visibility_level        = "private"
        wiki                    = "disabled"
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
        overall                 = "private"
        analytics               = "enabled"
        builds                  = "private"
        container_registry      = "private"
        environments            = "disabled"
        feature_flags           = "private"
        forking                 = "private"
        infrastructure          = "disabled"
        issues                  = "private"
        merge_requests          = "private"
        monitor                 = "private"
        packages                = "private"
        pages                   = "public"
        releases                = "private"
        repository              = "private"
        requirements            = "private"
        snippets                = "disabled"
        security_and_compliance = "private"
        visibility_level        = "private"
        wiki                    = "disabled"
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
        overall                 = "private"
        analytics               = "enabled"
        builds                  = "private"
        container_registry      = "private"
        environments            = "private"
        feature_flags           = "disabled"
        forking                 = "private"
        infrastructure          = "private"
        issues                  = "disabled"
        merge_requests          = "disabled"
        monitor                 = "private"
        packages                = "disabled"
        pages                   = "private"
        releases                = "disabled"
        repository              = "private"
        requirements            = "private"
        snippets                = "disabled"
        security_and_compliance = "private"
        visibility_level        = "private"
        wiki                    = "disabled"
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
