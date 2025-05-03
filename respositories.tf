resource "gitlab_project" "repositories" {
  for_each = {
    for key, value in var.repositories : key => value
    if value.gitlab
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
  auto_cancel_pending_pipelines                    = try(each.value.auto_cancel_pending_pipelines, false) ? "disabled" : "enabled"
  auto_devops_deploy_strategy                      = try(each.value.auto_devops_deploy_strategy, "continuous") #"continuous" #continuous, manual, timed_incremental
  auto_devops_enabled                              = try(each.value.auto_devops_enabled, false)
  autoclose_referenced_issues                      = true
  build_git_strategy                               = "fetch"
  build_timeout                                    = try(each.value.build_timeout, 3600)
  builds_access_level                              = try(each.value.access_level.builds, each.value.access_level.overall)
  ci_default_git_depth                             = 20
  ci_forward_deployment_enabled                    = true
  ci_separated_caches                              = true
  container_registry_access_level                  = try(each.value.access_level.container_registry, each.value.access_level.overall)
  default_branch                                   = try(each.value.default_branch, "main")
  emails_enabled                                   = false
  environments_access_level                        = try(each.value.access_level.environments, each.value.access_level.overall)
  feature_flags_access_level                       = try(each.value.access_level.feature_flags, each.value.access_level.overall)
  forked_from_project_id                           = 0
  forking_access_level                             = try(each.value.access_level.forking, each.value.access_level.overall)
  infrastructure_access_level                      = try(each.value.access_level.infrastructure, each.value.access_level.overall)
  issues_access_level                              = try(each.value.access_level.issues, each.value.access_level.overall)
  issues_enabled                                   = try(each.value.access_level.issues == "disabled" ? false : true, each.value.access_level.overall == "disabled" ? false : true)
  keep_latest_artifact                             = try(each.value.keep_latest_artifact, true)
  lfs_enabled                                      = try(each.value.lfs_enabled, true)
  merge_method                                     = "ff" # merge, rebase_merge, ff
  merge_pipelines_enabled                          = try(each.value.merge_pipelines_enabled, false)
  merge_requests_access_level                      = try(each.value.merge_requests_enabled, false) ? try(each.value.access_level.merge_requests, each.value.access_level.overall) : "disabled"
  merge_requests_enabled                           = try(each.value.merge_requests_enabled, false)
  merge_trains_enabled                             = false
  monitor_access_level                             = try(each.value.access_level.monitor, each.value.access_level.overall)
  mr_default_target_self                           = false
  only_allow_merge_if_all_discussions_are_resolved = try(each.value.only_allow_merge_if_all_discussions_are_resolved, true)
  only_allow_merge_if_pipeline_succeeds            = try(each.value.only_allow_merge_if_pipeline_succeeds, true)
  packages_enabled                                 = try(each.value.packages_enabled, false)
  pages_access_level                               = try(each.value.access_level.pages, each.value.access_level.overall)
  printing_merge_request_link_enabled              = true
  releases_access_level                            = try(each.value.access_level.releases, each.value.access_level.overall)
  remove_source_branch_after_merge                 = true
  repository_access_level                          = try(each.value.access_level.repository, each.value.access_level.overall)
  request_access_enabled                           = try(each.value.request_access_enabled, false)
  requirements_access_level                        = try(each.value.access_level.requirements, each.value.access_level.overall)
  resolve_outdated_diff_discussions                = false
  restrict_user_defined_variables                  = false
  security_and_compliance_access_level             = try(each.value.access_level.security_and_compliance, each.value.access_level.overall)
  shared_runners_enabled                           = try(each.value.has_sharedruners, true)
  snippets_access_level                            = try(each.value.access_level.snippets, each.value.access_level.overall)
  snippets_enabled                                 = try(each.value.access_level.snippets == "disabled" ? false : true, each.value.access_level.overall == "disabled" ? false : true)
  squash_option                                    = "default_off"
  import_url                                       = try(each.value.import_url, null)
  visibility_level                                 = each.value.access_level.visibility_level
  wiki_access_level                                = try(each.value.access_level.wiki, each.value.access_level.overall)
  wiki_enabled                                     = try(each.value.access_level.wiki == "disabled" ? false : true, each.value.access_level.overall == "disabled" ? false : true)
  #http_url_to_repo                                 = "https://gitlab.com/papanito/git-hooks.git"
  #import_url                                       = gitlab_project.git-hooks.http_url_to_repo
  #   mirror                                           = false
  #   mirror_overwrites_diverged_branches              = false
  #   mirror_trigger_builds                            = false
  #   only_mirror_protected_branches                   = false
  tags   = try(each.value.tags, [])
  topics = try(each.value.tags, [])
  container_expiration_policy {
    cadence           = "1d"
    enabled           = false
    keep_n            = 10
    name_regex_delete = ".*"
    older_than        = "90d"
  }
}
