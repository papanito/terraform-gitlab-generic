locals {
  gitlab_repositories = {
    for repo_name, config in local.repositories : repo_name => merge(
      [
        for is_mirror in [
          # Mirror ONLY if primary_repo is explicitly TRUE
          try(config.github.primary_repo, false) == true
          ] : {

          description = is_mirror ? "[MIRROR] ${config.description}" : config.description

          access_level = is_mirror ? (
            strcontains(config.access_level, "public") ? local.acl["public-mirror"].gitlab : local.acl["private-mirror"].gitlab
          ) : local.acl[config.access_level].gitlab

          topics = config.topics
        }
      ][0],
      {
        for is_mirror in [lookup(config, "github", null) != null] : "mirror_payload" => {
          # Standalone URL - only if mirror is true
          import_url = is_mirror ? "https://github.com/${coalesce(try(config.github.org, null), var.github_user)}/${repo_name}.git" : null

          # List of objects - only if mirror is true
          mirrors = is_mirror ? [
            {
              enabled                 = true
              scm_type                = "github"
              url                     = "https://${var.github_mirror_user}:${var.github_mirror_token}@github.com/${coalesce(try(config.github.org, null), var.github_mirror_user)}/${repo_name}.git"
              keep_divergent_refs     = false
              only_protected_branches = true
            }
          ] : []
        }
      }["mirror_payload"], # Immediately extract the result of the mirror check
      {
        name           = try(config.name, null)
        archived       = try(config.archived, null)
        default_branch = try(config.default_branch, null)
        avatar         = try(config.avatar, null) # This preserves it if present
        group_name     = try(config.gitlab.group_name, null)
        approval_rules = try(config.gitlab.approval_rules, local.approval_rules["minimal"])
      }
    )
    if can(config.gitlab)
  }
}

module "gitlab" {
  source       = "../"
  repositories = local.gitlab_repositories
  groups       = local.groups
}

removed {
  from = module.gitlab.gitlab_user.users

  lifecycle {
    destroy = false
  }
}

output "flat_rules" {
  value = module.gitlab.flat_rules
}

output "flat_protected_branches" {
  value = module.gitlab.flat_protected_branches
}

output "debug_protected_branches" {
  value = module.gitlab.protected_branches
}

