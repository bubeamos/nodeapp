variable "repository_url" {
  description = "The url of the ECR repository"
}

variable "region" {
  description = "The region to use"
}

variable "ecs_cluster_name" {
  description = "The cluster that we will deploy to"
}

variable "ecs_service_name" {
  description = "The ECS service that will be deployed"
}

variable "github_webhooks_token" {
  description = "Token To Enable GitHub API Calls, Should have the following permissions repo,repo:status,admin:repo_hook https://docs.aws.amazon.com/codebuild/latest/userguide/sample-access-tokens.html#sample-access-tokens-prerequisites"
}

variable "github_repo_name" {
  description = "GitHub Repo Name"
  default = "nodeapp"
}

variable "aws_account_id" {
  description = "AWS Account ID Where Resources Will Be Deployed"
}

variable "source_bucket" {
  description = "Bucket For CodeBuild Artifacts"
}

variable "repo_owner" {
  description = "NodeApp GitHub Repo Owener"
  default = "Chidiebube"
}

variable "branch" {
  description = "Branch To Build App From"
  default = "master"
}




