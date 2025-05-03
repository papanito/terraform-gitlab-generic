variable "repositories" {
  description = <<EOF
List of repositories. The list is written in a "generic" way, so we can use it for gitlab, github, .....
Each entry contains
- `description`: Description of the repo
- `gitlab`: `true` if the repo shal be created in gitlab. Default: `false`
- `github`: `true` if the repo shal be created in github. Default: `false`
- `archived`: `true` if repo is marked as archived. Default: `false`
- `access_level`: object that contains access level


**`access_level`**

Object contains a list of string. Valid values are `disabled`, `private`, `enabled`.

- `overall`: If specific setting below no defined, this setting is taken
- `analytics`: Set the analytics access level. 
- `builds`: Set the builds access level.
- `container_registry`: Set visibility of container registry, for this project
- `environments`: Set the environments access level
- `feature_flags`: Set the feature flags access level
- `forking`: Set the forking access level.
- `infrastructure`: Set the infrastructure access level
- `issues`: Enable issue tracking for the project
- `merge_requests`: Set the merge requests access level
- `monitor`: Set the monitor access level. 
- `packages`: Enable packages repository for the project
- `pages`: Enable pages access control. 
- `releases`: Set the releases access level.
- `repository`: Set the repository access level.
- `requirements`: Set the requirements access level
- `snippets`: ) Set the snippets access level.
- `security_and_compliance`: 
- `visibility_level`:  Set to public to create a public project. Valid values are `private`, `internal`, `public`.
- `wiki`: Set the wiki access level

**Remarks**
- `public_jobs` will be set according to `builds` access level

EOF
  type = map(object({
    name                   = optional(string)
    description            = string
    group_name             = optional(string)
    avatar                 = optional(string)
    gitlab                 = optional(bool, false)
    github                 = optional(bool, false)
    archived               = optional(bool, false)
    approvals_before_merge = optional(number, 1)
    access_level = object({
      overall                 = string
      analytics               = string
      builds                  = string
      container_registry      = string
      environments            = string
      feature_flags           = string
      forking                 = string
      infrastructure          = string
      issues                  = string
      merge_requests          = string
      monitor                 = string
      packages                = string
      pages                   = string
      releases                = string
      repository              = string
      requirements            = string
      snippets                = string
      security_and_compliance = string
      visibility_level        = string
      wiki                    = string
    })
    default_branch = optional(string, "main")
    import_url     = optional(string)
    tags           = list(string)
    }
  ))
  validation {
    condition = alltrue(flatten(
      [for repo in var.repositories :
        [for setting in repo.access_level :
        contains(["disabled", "private", "enabled", "public"], setting)]
      ]
    ))
    error_message = "All access level elements must be one of disabled, private or enabled"
  }
  # validation {
  #   condition     = can(regex("^(master|main)", var.repositories.default_branch))
  #   error_message = "The default branch is usually 'main' or 'master'."
  # }
  # validation {
  #   condition     = can(regex("^(ssh|https)://.*", var.repositories.import_url))
  #   error_message = "The `import_url` starts with `ssh://` or `https://`."
  # }
}

variable "groups" {
  description = "List of groups"
  type = map(object({
    name             = optional(string)
    description      = string
    avatar           = optional(string)
    visibility_level = string

    auto_devops_enabled                = optional(bool, false)
    emails_enabled                     = optional(bool, true)
    extra_shared_runners_minutes_limit = optional(number, 0)
    two_factor_grace_period            = optional(number, 24)
    ip_restriction_ranges              = optional(list(string), [])
    lfs_enabled                        = optional(bool, true)
    membership_lock                    = optional(bool, false)
    mentions_disabled                  = optional(bool, false)
    path                               = optional(string)
    parent_name                        = optional(string, null)
    prevent_forking_outside_group      = optional(bool, false)
    request_access_enabled             = optional(bool, false)
    require_two_factor_authentication  = optional(bool, true)
    share_with_group_lock              = optional(bool, true)
    project_creation_level             = string # Determine if developers can create projects in the group.
    subgroup_creation_level            = optional(string, "owner")
    wiki_access_level                  = optional(string, "private")
    default_branch_protection_defaults = optional(object({
      allow_force_push           = bool
      allowed_to_merge           = list(string) # developer, maintainer, no one.
      allowed_to_push            = list(string) #string # developer, maintainer, no one.
      developer_can_initial_push = bool
      }),
      {
        allow_force_push           = false
        allowed_to_merge           = ["maintainer"]
        allowed_to_push            = ["developer", "maintainer"]
        developer_can_initial_push = true
    })
  }))

  validation {
    condition = alltrue(
      [for group in var.groups :
        contains(["noone", "owner", "maintainer", "developer"], group.project_creation_level)
      ]
    )
    error_message = "project_creation_level must be one of these values: noone, owner, maintainer, developer"
  }
  validation {
    condition = alltrue(
      [for group in var.groups :
        contains(["disabled", "private", "enabled"], group.wiki_access_level)
      ]
    )
    error_message = "wiki_access_level must be one of these values: disabled, private, enabled"
  }
  validation {
    condition = alltrue(
      [for group in var.groups :
        contains(["private", "internal", "public"], group.visibility_level)
      ]
    )
    error_message = "visibility_level must be one of these values: private, internal, public"
  }
}

