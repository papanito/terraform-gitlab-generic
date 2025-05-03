# tf-module-gitlab

Terraform module to simplify gitlab setup of groups and projects.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0, < 2.0.0 |
| <a name="requirement_gitlab"></a> [gitlab](#requirement\_gitlab) | >= 17.0.0, < 18.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_gitlab"></a> [gitlab](#provider\_gitlab) | >= 17.0.0, < 18.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [gitlab_group.groups](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/group) | resource |
| [gitlab_project.repositories](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [gitlab_groups.groups](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/data-sources/groups) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_groups"></a> [groups](#input\_groups) | List of groups | <pre>map(object({<br/>    name             = optional(string)<br/>    description      = string<br/>    avatar           = optional(string)<br/>    visibility_level = string<br/><br/>    auto_devops_enabled                = optional(bool, false)<br/>    emails_enabled                     = optional(bool, true)<br/>    extra_shared_runners_minutes_limit = optional(number, 0)<br/>    two_factor_grace_period            = optional(number, 24)<br/>    ip_restriction_ranges              = optional(list(string), [])<br/>    lfs_enabled                        = optional(bool, true)<br/>    membership_lock                    = optional(bool, false)<br/>    mentions_disabled                  = optional(bool, false)<br/>    path                               = optional(string)<br/>    parent_name                        = optional(string, null)<br/>    prevent_forking_outside_group      = optional(bool, false)<br/>    request_access_enabled             = optional(bool, false)<br/>    require_two_factor_authentication  = optional(bool, true)<br/>    share_with_group_lock              = optional(bool, true)<br/>    project_creation_level             = string # Determine if developers can create projects in the group.<br/>    subgroup_creation_level            = optional(string, "owner")<br/>    wiki_access_level                  = optional(string, "private")<br/>    default_branch_protection_defaults = optional(object({<br/>      allow_force_push           = bool<br/>      allowed_to_merge           = list(string) # developer, maintainer, no one.<br/>      allowed_to_push            = list(string) #string # developer, maintainer, no one.<br/>      developer_can_initial_push = bool<br/>      }),<br/>      {<br/>        allow_force_push           = false<br/>        allowed_to_merge           = ["maintainer"]<br/>        allowed_to_push            = ["developer", "maintainer"]<br/>        developer_can_initial_push = true<br/>    })<br/>  }))</pre> | n/a | yes |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | List of repositories. The list is written in a "generic" way, so we can use it for gitlab, github, .....<br/>Each entry contains<br/>- `description`: Description of the repo<br/>- `gitlab`: `true` if the repo shal be created in gitlab. Default: `false`<br/>- `github`: `true` if the repo shal be created in github. Default: `false`<br/>- `archived`: `true` if repo is marked as archived. Default: `false`<br/>- `access_level`: object that contains access level<br/><br/><br/>**`access_level`**<br/><br/>Object contains a list of string. Valid values are `disabled`, `private`, `enabled`.<br/><br/>- `overall`: If specific setting below no defined, this setting is taken<br/>- `analytics`: Set the analytics access level. <br/>- `builds`: Set the builds access level.<br/>- `container_registry`: Set visibility of container registry, for this project<br/>- `environments`: Set the environments access level<br/>- `feature_flags`: Set the feature flags access level<br/>- `forking`: Set the forking access level.<br/>- `infrastructure`: Set the infrastructure access level<br/>- `issues`: Enable issue tracking for the project<br/>- `merge_requests`: Set the merge requests access level<br/>- `monitor`: Set the monitor access level. <br/>- `packages`: Enable packages repository for the project<br/>- `pages`: Enable pages access control. <br/>- `releases`: Set the releases access level.<br/>- `repository`: Set the repository access level.<br/>- `requirements`: Set the requirements access level<br/>- `snippets`: ) Set the snippets access level.<br/>- `security_and_compliance`: <br/>- `visibility_level`:  Set to public to create a public project. Valid values are `private`, `internal`, `public`.<br/>- `wiki`: Set the wiki access level<br/><br/>**Remarks**<br/>- `public_jobs` will be set according to `builds` access level | <pre>map(object({<br/>    name                   = optional(string)<br/>    description            = string<br/>    group_name             = optional(string)<br/>    avatar                 = optional(string)<br/>    gitlab                 = optional(bool, false)<br/>    github                 = optional(bool, false)<br/>    archived               = optional(bool, false)<br/>    approvals_before_merge = optional(number, 1)<br/>    access_level = object({<br/>      overall                 = string<br/>      analytics               = string<br/>      builds                  = string<br/>      container_registry      = string<br/>      environments            = string<br/>      feature_flags           = string<br/>      forking                 = string<br/>      infrastructure          = string<br/>      issues                  = string<br/>      merge_requests          = string<br/>      monitor                 = string<br/>      packages                = string<br/>      pages                   = string<br/>      releases                = string<br/>      repository              = string<br/>      requirements            = string<br/>      snippets                = string<br/>      security_and_compliance = string<br/>      visibility_level        = string<br/>      wiki                    = string<br/>    })<br/>    default_branch = optional(string, "main")<br/>    import_url     = optional(string)<br/>    tags           = list(string)<br/>    }<br/>  ))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_groups"></a> [groups](#output\_groups) | n/a |
<!-- END_TF_DOCS -->