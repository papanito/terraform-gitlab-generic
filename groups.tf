resource "gitlab_group" "groups" {
  for_each = {
    for key, value in var.groups : key => value
    #if value.gitlab
  }
  name        = each.value.name == null ? each.key : each.value.name
  description = each.value.parent_name != null ? format("%s [%s]", each.value.description, each.value.parent_name) : each.value.description

  auto_devops_enabled                = each.value.auto_devops_enabled
  emails_enabled                     = each.value.emails_enabled
  extra_shared_runners_minutes_limit = each.value.extra_shared_runners_minutes_limit
  shared_runners_minutes_limit       = 0
  ip_restriction_ranges              = each.value.ip_restriction_ranges
  lfs_enabled                        = each.value.lfs_enabled
  membership_lock                    = each.value.membership_lock
  mentions_disabled                  = each.value.mentions_disabled
  path                               = each.value.path != null ? each.value.path : each.key
  parent_id                          = each.value.parent_name == null ? 0 : local.groups[each.value.parent_name].group_id
  prevent_forking_outside_group      = each.value.prevent_forking_outside_group
  project_creation_level             = each.value.project_creation_level
  request_access_enabled             = each.value.request_access_enabled
  require_two_factor_authentication  = each.value.require_two_factor_authentication
  share_with_group_lock              = each.value.share_with_group_lock
  subgroup_creation_level            = each.value.subgroup_creation_level
  two_factor_grace_period            = each.value.two_factor_grace_period
  visibility_level                   = each.value.visibility_level
  wiki_access_level                  = each.value.wiki_access_level
  avatar                             = try("./resources/${each.value.avatar}", null)
  avatar_hash                        = try(filesha256("./resources/${each.value.avatar}"), null)
  default_branch_protection_defaults {
    allow_force_push           = each.value.default_branch_protection_defaults.allow_force_push
    allowed_to_merge           = each.value.default_branch_protection_defaults.allowed_to_merge
    allowed_to_push            = each.value.default_branch_protection_defaults.allowed_to_push
    developer_can_initial_push = each.value.default_branch_protection_defaults.developer_can_initial_push
  }
}
