/* AWS/Git Providers */
provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "default"
  region                  = "${var.region}"
}


provider "github" {
  token        = "${var.github_webhooks_token}"
  organization = "${var.github_organization}"
  individual = true
}