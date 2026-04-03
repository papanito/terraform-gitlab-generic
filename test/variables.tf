variable "github_user" {
  description = "The GitHub username or organzization for the repo links"
  type        = string
  default     = "clawfinger"
}

variable "gitlab_user" {
  description = "The Gitlab username or organization of the repo links"
  type        = string
  default     = "clawfinger"
}

variable "github_mirror_user" {
  description = "The GitHub username used for mirroring authentication."
  type        = string
  default     = "clawfinger"
}

variable "github_mirror_token" {
  description = "Personal Access Token for GitHub with repo read permissions."
  type        = string
  sensitive   = true
}
