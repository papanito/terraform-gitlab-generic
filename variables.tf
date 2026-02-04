variable "repositories" {
  description = <<EOF
List of repositories. The list is written in a "generic" way, so we can use it for gitlab, github, .....
Each entry contains

<ul><li>`description`: (String)Description of the repo</li>
<li>`avatar`: (String) File name of the avatar, assoumes it's in a subfolder `resources`</li>
<li>`archived`: (Boolean) if repo is marked as archived.</li>
<li>`free_tier`: (Boolean) if repo is marked as free-tier, then we ignore features related to licensed versions only.</li>
<li>`access_level`: (Object) object that contains access level</li>
<li>`approvals_before_merge`: Number) Number of merge request approvals required for merging.>
</ul>

**Access Config `access_level`**

Object contains a list of string. Valid values are `disabled`, `private`, `enabled`.

<ul><li>`overall`: If specific setting below no specified, this setting is taken</li>
<li>`analytics`: Set the analytics access level. </li>
<li>`builds`: Set the builds access level.</li>
<li>`container_registry`: Set visibility of container registry, for this project</li>
<li>`environments`: Set the environments access level</li>
<li>`feature_flags`: Set the feature flags access level</li>
<li>`forking`: Set the forking access level.</li>
<li>`infrastructure`: Set the infrastructure access level</li>
<li>`issues`: Enable issue tracking for the project</li>
<li>`merge_requests`: Set the merge requests access level</li>
<li>`monitor`: Set the monitor access level. </li>
<li>`packages`: Enable packages repository for the project</li>
<li>`pages`: Enable pages access control. </li>
<li>`releases`: Set the releases access level.</li>
<li>`repository`: Set the repository access level.</li>
<li>`requirements`: Set the requirements access level</li>
<li>`snippets`: Set the snippets access level.</li>
<li>`security_and_compliance`: </li>
<li>`visibility_level`:  Set to public to create a public project. Valid values are `private`, `internal`, `public`.
<li>`wiki`: Set the wiki access level</li></ul>

**Pipeline config `ci_config` **

<ul><li>`ci_config_path` (String) Custom Path to CI config file.</li>
<li>`ci_default_git_depth` (Number) Default number of revisions for shallow cloning.</li>
<li>`ci_delete_pipelines_in_seconds` (Number) Pipelines older than the configured time are deleted.</li>
<li>`ci_forward_deployment_enabled` (Boolean) When a new deployment job starts, skip older deployment jobs that are still pending.</li>
<li>`ci_id_token_sub_claim_components` (List of String) Fields included in the sub claim of the ID Token. Accepts an array starting with project_path. The array might also include ref_type and ref. Defaults to ["project_path", "ref_type", "ref"]. Introduced in GitLab 17.10.</li>
<li>`ci_pipeline_variables_minimum_override_role` (String) The minimum role required to set variables when running pipelines and jobs. Introduced in GitLab 17.1. Valid values are developer, maintainer, owner, no_one_allowed</li>
<li>`ci_restrict_pipeline_cancellation_role` (String) The role required to cancel a pipeline or job. Premium and Ultimate only. Valid values are `developer`, `maintainer`, `no one`</li>
<li>`ci_separated_caches` (Boolean) Use separate caches for protected branches.</li>
<li>`restrict_user_defined_variables` (Boolean) Allow only users with the Maintainer role to pass user-defined variables when triggering a pipeline.</li>
</ul>

** SCM Mirrors `mirrors**

A list of external SCM sources to pull from.
<ul>
  <li><b>enabled</b>: If set to true, the mirror will actively synchronize. Defaults to true.</li>
  <li><b>scm_type</b>: Name of the remote scm e.g. github
  <li><b>url</b>: The full authenticated URL of the remote repository.</li>
  <li><b>keep_divergent_refs</b>: If true, mirroring will not overwrite local changes that have diverged from the source.</li>
  <li><b>only_protected_branches</b>: If true, only branches protected in the source will be synchronized.</li>
</ul>

**Remarks**

`public_jobs` will be set according to `builds` access level

EOF
  type = map(object({
    name                   = optional(string)
    description            = string
    free_tier              = optional(bool, true)
    group_name             = optional(string)
    avatar                 = optional(string)
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
    ci_config = optional(object({
      ci_config_path                              = optional(string)
      ci_default_git_depth                        = optional(number, 20)
      ci_delete_pipelines_in_seconds              = optional(number, 31536000)
      ci_forward_deployment_enabled               = optional(bool, true)
      ci_restrict_pipeline_cancellation_role      = optional(string, "maintainer")
      ci_pipeline_variables_minimum_override_role = optional(string, "no_one_allowed")
      ci_separated_caches                         = optional(bool, true)
      restrict_user_defined_variables             = optional(bool, true)
    }))
    # Mirroring configuration to pull from external SCMs
    mirrors = optional(list(object({
      enabled                 = optional(bool, true)
      scm_type                = string
      url                     = string
      keep_divergent_refs     = optional(bool, false)
      only_protected_branches = optional(bool, false)
    })), [])
    labels = optional(map(object({
      name        = string
      description = string
      color       = string
    })), {})
    default_branch = optional(string)
    import_url     = optional(string)
    topics         = list(string)
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
  #   condition = alltrue(
  #     [for project in var.repositories :
  #       contains(["no one", "maintainer", "developer"], project.ci_config.ci_restrict_pipeline_cancellation_role)
  #     ]
  #   )
  #   error_message = "project_creation_level must be one of these values: no one, maintainer, developer"
  # }
  # validation {
  #   condition     = can(regex("^(master|main)", var.repositories.default_branch))
  #   error_message = "The<br>Default branch is usually 'main' or 'master'."
  # }
  # validation {
  #   condition     = can(regex("^(ssh|https)://.*", var.repositories.import_url))
  #   error_message = "The `import_url` starts with `ssh://` or `https://`."
  # }
}

variable "groups" {
  description = <<EOF
List of repositories. The list is written in a "generic" way, so we can use it for gitlab, github, .....
Each entry contains

<ul><li>`description`: (String) Description of the repo</li>
<li>`avatar`: (String) File name of the avatar, assoumes it's in a subfolder `resources`</li>
<li>`visibility_level`: (String) Set to public to create a public project. Valid values are `private`, `internal`, `public`.</li>
<li>`gitlab`: (Boolean) if the repo shal be created in gitlab.</li>
<li>`github`: (Boolean) if the repo shal be created in github.</li>
<li>`auto_devops_enabled`: (Boolean)<br>Default to Auto DevOps pipeline for all projects within this group.</li>
<li>`emails_enabled`: (Boolean) Enable email notifications.</li>
<li>`default_branch`: (String) Initial<br>Default branch name.</li>
<li>`extra_shared_runners_minutes_limit`: (Number) Additional CI/CD minutes for this group.</li>
<li>`two_factor_grace_period`: (Number) Time before Two-factor authentication is enforced (in hours).</li>
<li>`ip_restriction_ranges`: (List of String) A list of IP addresses or subnet masks to restrict group access. Will be concatenated together into a comma separated string. Only allowed on top level groups.
<li>`lfs_enabled`: (Boolean) Enable/disable Large File Storage (LFS) for the projects in this group.</li>
<li>`membership_lock`: (Boolean) Users cannot be added to projects in this group.</li>
<li>`mentions_disabled`:  (Boolean) Disable the capability of a group from getting mentioned.</li>
<li>`path`: (String) Override path. This might be necessary to avoid duplication.<br>Default is the keyname of the the group element</li>
<li>`parent_name`: "key" of the parent group from the group map</li>
<li>`prevent_forking_outside_group`: (Boolean) When enabled, users can not fork projects from this group to external namespaces.</li>
<li>`request_access_enabled`: (Boolean) Allow users to request member access.</li>
<li>`require_two_factor_authentication`: (Boolean) Require all users in this group to setup Two-factor authentication.</li>
<li>`share_with_group_lock`: (Boolean) Prevent sharing a project with another group within this group.</li>
<li>`project_creation_level`: (String) Determine if developers can create projects in the group. Valid values are: `noone`, `owner`, `maintainer`, `developer`.</li>
<li>`subgroup_creation_level`: String) Allowed to create subgroups. Valid values are: `owner`, `maintainer`.</li>`
<li>`wiki_access_level`:  (String) The group's wiki access level. Only available on Premium and Ultimate plans. Valid values are disabled, private, enabled.</li>
<li>`default_branch_protection_defaults`: (Block List, Max: 1) The default branch protection defaults </li>
<li>``: (Boolean) if the repo shal be created in github.</li><ul>

EOF
  type = map(object({
    name             = optional(string)
    description      = string
    avatar           = optional(string)
    visibility_level = string

    auto_devops_enabled                = optional(bool, false)
    emails_enabled                     = optional(bool, false)
    default_branch                     = optional(string, "main")
    extra_shared_runners_minutes_limit = optional(number, 0)
    two_factor_grace_period            = optional(number, 24)
    require_two_factor_authentication  = optional(bool, true)
    ip_restriction_ranges              = optional(list(string), [])
    lfs_enabled                        = optional(bool, true)
    membership_lock                    = optional(bool, true)
    mentions_disabled                  = optional(bool, false)
    path                               = optional(string)
    parent_name                        = optional(string, null)
    prevent_forking_outside_group      = optional(bool, false)
    request_access_enabled             = optional(bool, false)
    share_with_group_lock              = optional(bool, true)
    project_creation_level             = optional(string, "owner")
    subgroup_creation_level            = optional(string, "owner")
    wiki_access_level                  = optional(string, "private")
    default_branch_protection_defaults = optional(object({
      allow_force_push           = bool
      allowed_to_merge           = list(string) # developer, maintainer, no one.
      allowed_to_push            = list(string) # developer, maintainer, no one.
      developer_can_initial_push = bool
      }),
      {
        allow_force_push           = true
        allowed_to_merge           = ["maintainer"]
        allowed_to_push            = ["maintainer"]
        developer_can_initial_push = true
    })
    labels = optional(map(object({
      description = string
      color       = string
    })), {})
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

