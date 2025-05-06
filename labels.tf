resource "gitlab_group_label" "labels" {
  for_each = {
    for key, value in local.group_labels : key => value
  }
  group       = each.value.group
  name        = each.value.key
  description = each.value.description
  color       = each.value.color
}

locals {
  group_labels = flatten([
    for group_key, group in var.groups : [
      for label_key, label_values in(lookup(group, "labels", {})) :
      {
        key         = label_key
        name        = label_key
        description = label_values.description
        color       = label_values.color
        group       = group.parent_name == null ? group_key : "${group.parent_name}/${group_key}"
      }
    ]
  ])
}