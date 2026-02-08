output "groups" {
  value = local.groups
}

output "group_labels" {
  value = local.group_labels
}

output "branch_protection_rules" {
  value = local.flat_rules
}

output "protected_branches" {
  value = data.gitlab_project_protected_branches.existing
}

output "protected_branches_managed" {
  value = gitlab_project_protected_branches.managed
}

