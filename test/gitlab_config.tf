locals {
  groups = {
    clawfinger-test = {
      name                   = "Clawfinger Test Group"
      description            = "Test group"
      project_creation_level = "owner"
      visibility_level       = "public"
      labels                 = local.default_labels
    }
  }
}

locals { # [Work usabilitype Classification](https://handbook.gitlab.com/handbook/product/groups/product-analysis/engineering/metrics/#work-type-classification)
  default_labels = {
    "type::bug" = {
      description = "Defects in shipped code and fixes for those defects. Read more about features vs bugs"
      color       = "#dc143c"
    }
  }
}
