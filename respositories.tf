resource "gitlab_project" "repositories" {
  for_each = {
    for key, value in var.repositories : key => value
  }
  name        = each.value.name == null ? each.key : each.value.name
  description = each.value.description

  avatar                                           = try("./resources/${each.value.avatar}", null)
  avatar_hash                                      = try(filesha256("./resources/${each.value.avatar}"), null)
  namespace_id                                     = try(each.value.group_name, null) != null ? local.groups[each.value.group_name].group_id : null
  allow_merge_on_skipped_pipeline                  = false
  analytics_access_level                           = try(each.value.access_level.analytics, each.value.access_level.overall)
  approvals_before_merge                           = each.value.approvals_before_merge
  archived                                         = try(each.value.archived, false)
  auto_cancel_pending_pipelines                    = try(each.value.auto_cancel_pending_pipelines, false) ? local.defaults.disabled : "enabled"
  auto_devops_deploy_strategy                      = try(each.value.auto_devops_deploy_strategy, "continuous") #"continuous" #continuous, manual, timed_incremental
  auto_devops_enabled                              = try(each.value.auto_devops_enabled, false)
  autoclose_referenced_issues                      = true
  build_git_strategy                               = "fetch"
  build_timeout                                    = try(each.value.build_timeout, 3600)
  builds_access_level                              = try(each.value.access_level.builds, each.value.access_level.overall)
  container_registry_access_level                  = try(each.value.access_level.container_registry, each.value.access_level.overall)
  default_branch                                   = try(each.value.default_branch, "main")
  emails_enabled                                   = false
  environments_access_level                        = try(each.value.access_level.environments, each.value.access_level.overall)
  feature_flags_access_level                       = try(each.value.access_level.feature_flags, each.value.access_level.overall)
  forked_from_project_id                           = 0
  forking_access_level                             = try(each.value.access_level.forking, each.value.access_level.overall)
  infrastructure_access_level                      = try(each.value.access_level.infrastructure, each.value.access_level.overall)
  issues_access_level                              = try(each.value.access_level.issues, each.value.access_level.overall)
  keep_latest_artifact                             = try(each.value.keep_latest_artifact, true)
  lfs_enabled                                      = try(each.value.lfs_enabled, true)
  merge_method                                     = "ff" # merge, rebase_merge, ff
  merge_pipelines_enabled                          = try(each.value.merge_pipelines_enabled, false)
  merge_requests_access_level                      = try(each.value.access_level.merge_requests, try(each.value.access_level.overall, local.defaults.disabled))
  merge_trains_enabled                             = false
  monitor_access_level                             = try(each.value.access_level.monitor, each.value.access_level.overall)
  mr_default_target_self                           = false
  only_allow_merge_if_all_discussions_are_resolved = try(each.value.only_allow_merge_if_all_discussions_are_resolved, true)
  only_allow_merge_if_pipeline_succeeds            = try(each.value.only_allow_merge_if_pipeline_succeeds, true)
  packages_enabled                                 = try(each.value.access_level.packages == "enabled" ? true : false, false)
  pages_access_level                               = try(each.value.access_level.pages, each.value.access_level.overall)
  printing_merge_request_link_enabled              = true
  releases_access_level                            = try(each.value.access_level.releases, each.value.access_level.overall)
  remove_source_branch_after_merge                 = true
  repository_access_level                          = try(each.value.access_level.repository, each.value.access_level.overall)
  request_access_enabled                           = try(each.value.request_access_enabled, false)
  requirements_access_level                        = try(each.value.access_level.requirements, each.value.access_level.overall)
  resolve_outdated_diff_discussions                = false
  security_and_compliance_access_level             = try(each.value.access_level.security_and_compliance, each.value.access_level.overall)
  shared_runners_enabled                           = try(each.value.has_sharedruners, true)
  snippets_access_level                            = try(each.value.access_level.snippets, each.value.access_level.overall)
  squash_option                                    = "default_off"
  import_url                                       = try(each.value.import_url, null)
  visibility_level                                 = each.value.access_level.visibility_level
  wiki_access_level                                = try(each.value.access_level.wiki, each.value.access_level.overall)

  ## CI Configuration
  #ci_delete_pipelines_in_seconds                   = each.value.ci_config.ci_delete_pipelines_in_seconds
  ci_config_path                              = try(each.value.ci_config.ci_config_path, null)
  ci_default_git_depth                        = try(each.value.ci_config.ci_default_git_depth, local.defaults.ci_default_git_depth)
  ci_forward_deployment_enabled               = try(each.value.ci_config.ci_forward_deployment_enabled, local.defaults.ci_forward_deployment_enabled)
  ci_separated_caches                         = try(each.value.ci_config.ci_separated_caches, local.defaults.ci_separated_caches)
  ci_restrict_pipeline_cancellation_role      = each.value.free_tier ? "" : try(each.value.ci_config.ci_restrict_pipeline_cancellation_role, local.defaults.ci_restrict_pipeline_cancellation_role)
  ci_pipeline_variables_minimum_override_role = try(each.value.ci_config.ci_pipeline_variables_minimum_override_role, local.defaults.ci_pipeline_variables_minimum_override_role)


  #http_url_to_repo                                 = "https://gitlab.com/papanito/git-hooks.git"
  #import_url                                       = gitlab_project.git-hooks.http_url_to_repo
  #   mirror                                           = false
  #   mirror_overwrites_diverged_branches              = false
  #   mirror_trigger_builds                            = false
  #   only_mirror_protected_branches                   = false
  topics = try(each.value.topics, [])
  container_expiration_policy {
    cadence           = "1d"
    enabled           = false
    keep_n            = 10
    name_regex_delete = ".*"
    older_than        = "90d"
  }
}
