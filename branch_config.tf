locals {
  # Flatten the map so we can iterate at the rule level
  flat_rules = flatten([
    for repo_key, repo_val in var.repositories : [
      for rule_name, rule_val in repo_val.approval_rules : {
        repo_id            = repo_key
        rule_name          = rule_name
        approvals_required = rule_val.approvals_required
        users              = rule_val.users
        groups             = rule_val.groups
        protected_branches = rule_val.protected_branches
      }
    ] if repo_val.archived == false # <--- Skip rules if the project is archived
  ])
}

# Lookup unique users across all repositories
data "gitlab_user" "resolved" {
  for_each = toset(flatten([for r in local.flat_rules : r.users]))
  username = each.value
}

# Lookup unique groups across all repositories
data "gitlab_group" "resolved" {
  for_each  = toset(flatten([for r in local.flat_rules : r.groups]))
  full_path = each.value
}

# Lookup protected branches for each repository
data "gitlab_project_protected_branches" "existing" {
  for_each   = gitlab_project.repositories
  project_id = each.value.id
}

resource "gitlab_project_approval_rule" "rules" {
  for_each = {
    for r in local.flat_rules : "${r.repo_id}.${r.rule_name}" => r
  }

  project            = each.value.repo_id
  name               = each.value.rule_name
  approvals_required = each.value.approvals_required

  # Convert Usernames to IDs via the data source map
  user_ids = [
    for u in each.value.users : data.gitlab_user.resolved[u].id
  ]

  # Convert Group Paths to IDs via the data source map
  group_ids = [
    for g in each.value.groups : data.gitlab_group.resolved[g].id
  ]

  protected_branch_ids = [
    for b_name in each.value.protected_branches :
    gitlab_branch_protection.managed["${each.value.repo_id}/${b_name}"].branch_id
  ]
}

locals {
  # Create a flat list of all branches that need protection
  flat_protected_branches = flatten([
    for repo_key, repo_config in var.repositories : [
      # We check if protected_branches exists and iterate over it
      for branch_name in try(repo_config.protected_branches, []) : {
        repo_key    = repo_key
        branch_name = branch_name
      }
    ]
  ])
}

resource "gitlab_branch_protection" "managed" {
  for_each = {
    for b in local.flat_protected_branches : "${b.repo_key}/${b.branch_name}" => b
  }
  project = gitlab_project.repositories[each.value.repo_key].id
  branch  = each.value.branch_name

  push_access_level      = "maintainer" # TODO
  merge_access_level     = "developer"  # TODO
  unprotect_access_level = "maintainer" # TODO
  allow_force_push       = false
}

