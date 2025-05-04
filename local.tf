data "gitlab_groups" "groups" {
  sort     = "desc"
  order_by = "name"
}

locals {
  groups = {
    for group in data.gitlab_groups.groups.groups : group.full_path => group
  }
  defaults = {
    ci_default_git_depth                        = 20
    ci_delete_pipelines_in_seconds              = 31536000
    ci_forward_deployment_enabled               = true
    ci_restrict_pipeline_cancellation_role      = "owner"
    ci_pipeline_variables_minimum_override_role = "no_one_allowed"
    ci_separated_caches                         = true
    restrict_user_defined_variables             = true
  }
}

