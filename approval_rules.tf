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
        branches           = rule_val.protected_branches
      }
    ]
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
data "gitlab_project_protected_branches" "protected_branches" {
  for_each   = gitlab_project.repositories
  project_id = each.value.id
  depends_on = [gitlab_branch_protection.rules]
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

  # Match Branch Names to Protected Branch IDs
  protected_branch_ids = flatten([
    for b_name in each.value.branches : [
      for pb in data.gitlab_project_protected_branches.protected_branches[each.value.repo_id].protected_branches : pb.id
      if pb.name == b_name
    ]
  ])
}
