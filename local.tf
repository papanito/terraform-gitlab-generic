data "gitlab_groups" "groups" {
  sort     = "desc"
  order_by = "name"
}

locals {
  groups = {
    for group in data.gitlab_groups.groups.groups : group.full_path => group
  }
}