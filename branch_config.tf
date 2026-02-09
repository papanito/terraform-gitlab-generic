locals {
  # 1. Flatten the rules (ensure the typo is fixed here!)
  flat_rules = flatten([
    for repo_id, repo_val in var.repositories : [
      for rule_name, rule_val in repo_val.approval_rules : {
        repo_id            = repo_id
        rule_name          = rule_name
        approvals_required = rule_val.approvals_required
        users              = rule_val.users
        groups             = rule_val.groups
        protected_branches = try(rule_val.protected_branches, [])
      }
    ] if try(repo_val.archived, false) == false
  ])

  # 2. Extract EVERY branch mentioned in the rules to ensure they get protected
  flat_protected_branches = distinct(flatten([
    for r in local.flat_rules : [
      for b_name in r.protected_branches : {
        repo_id     = r.repo_id
        branch_name = b_name
      }
    ]
  ]))
}

output "debug_flat_rules" {
  value = {
    for r in local.flat_rules : "${r.repo_id}.${r.rule_name}" => r.protected_branches
  }
}

output "debug_protections" {
  value = local.flat_protected_branches
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

# resource "gitlab_project_approval_rule" "rules" {
#   for_each = {
#     for r in local.flat_rules : "${r.repo_id}.${r.rule_name}" => r
#   }
#
#   project            = each.value.repo_id
#   name               = each.value.rule_name
#   approvals_required = each.value.approvals_required
#
#   # Convert Usernames to IDs via the data source map
#   user_ids = [
#     for u in each.value.users : data.gitlab_user.resolved[u].id
#   ]
#
#   # Convert Group Paths to IDs via the data source map
#   group_ids = [
#     for g in each.value.groups : data.gitlab_group.resolved[g].id
#   ]
#
#   protected_branch_ids = flatten([
#     for b_name in each.value.protected_branches : [
#       for pb in try(data.gitlab_project_protected_branches.existing[each.value.repo_id].protected_branches, []) :
#       tonumber(pb.id) if pb.name == b_name
#     ]
#   ])
# }
#
locals {
  protected_branch_ids = {
    for r in local.flat_rules : "${r.repo_id}.${r.rule_name}" => flatten([
      for b_name in r.protected_branches : [
        for pb in try(data.gitlab_project_protected_branches.existing[r.repo_id].protected_branches, []) :
        tonumber(pb.id) if pb.name == b_name
      ]
    ])
  }
}

output "protected_branch_ids" {
  value = local.protected_branch_ids
}

resource "gitlab_branch_protection" "managed" {
  for_each = {
    for b in local.flat_protected_branches : "${b.repo_id}/${b.branch_name}" => b
  }
  project = gitlab_project.repositories[each.value.repo_id].id
  branch  = each.value.branch_name

  push_access_level      = "maintainer" # TODO
  merge_access_level     = "developer"  # TODO
  unprotect_access_level = "maintainer" # TODO
  allow_force_push       = false
}

