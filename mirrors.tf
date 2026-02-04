locals {
  # Flatten the map into a list of "mirror instances" for the resource
  project_mirrors = flatten([
    for repo_name, repo_data in var.repositories : [
      for mirror in repo_data.mirrors : {
        key                     = "${repo_name}-${mirror.scm_type}"
        project                 = repo_name
        url                     = mirror.url
        enabled                 = mirror.enabled
        keep_divergent_refs     = mirror.keep_divergent_refs
        only_protected_branches = mirror.only_protected_branches
      }
    ]
  ])
}

resource "gitlab_project_mirror" "mirrors" {
  for_each = { for m in local.project_mirrors : m.key => m }

  project = module.gitlab.repositories[each.value.project]
  url     = each.value.url
  enabled = each.value.enabled

  keep_divergent_refs     = each.value.keep_divergent_refs
  only_protected_branches = each.value.only_protected_branches
}
