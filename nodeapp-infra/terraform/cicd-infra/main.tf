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

resource "aws_s3_bucket" "source" {
  bucket        = "${var.source_bucket}"
  acl           = "private"
  force_destroy = true
}


/* policies/roles */
resource "aws_iam_role" "codepipeline_role" {
  name               = "codepipeline-role"

  assume_role_policy = file("./policies/codepipeline_role.json")
}


data "template_file" "codepipeline_policy" {
  template = "${file("${path.module}/policies/codepipeline.json")}"

  vars = {
    aws_s3_bucket_arn = "${aws_s3_bucket.source.arn}"
  }

}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = "${aws_iam_role.codepipeline_role.id}"
  policy = "${data.template_file.codepipeline_policy.rendered}"
}

resource "aws_iam_role" "codebuild_role" {
  name               = "codebuild-role"

  assume_role_policy = file("./policies/codebuild_role.json")
}

data "template_file" "codebuild_policy" {

  template = file("./policies/codebuild_policy.json")

  vars = {
    aws_s3_bucket_arn = "${aws_s3_bucket.source.arn}"
  }
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name        = "codebuild-policy"
  role        = "${aws_iam_role.codebuild_role.id}"
  policy      = "${data.template_file.codebuild_policy.rendered}"
}

/*
/* CodeBuild
*/

resource "aws_codebuild_project" "nodeapp_build" {
  name          = "nodeapp-codebuild"
  build_timeout = "10"
  service_role  = "${aws_iam_role.codebuild_role.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:2.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "AWS_REGION"
      value = "${var.region}"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = "${var.aws_account_id}"
    }

  }

  source {
    type      = "CODEPIPELINE"
  }
}

/* CodePipeline */

resource "aws_codepipeline" "nodeapp_pipeline" {
  name     = "nodeapp_pipeline"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.source.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        Owner      = "${var.repo_owner}"
        Repo       = "nodeapp"
        Branch     = "${var.branch}"
        OAuthToken = "${var.github_webhooks_token}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source"]
      output_artifacts = ["imagedefinitions"]

      configuration = {
        ProjectName = "nodeapp-codebuild"
      }
    }
  }

  stage {
    name = "Production"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["imagedefinitions"]
      version         = "1"

      configuration =  {
        ClusterName = "${var.ecs_cluster_name}"
        ServiceName = "${var.ecs_service_name}"
        FileName    = "imagedefinitions.json"
      }
    }
  }
}

# Automatically Create a WebHook From CodePipeline To GitHUb
resource "aws_codepipeline_webhook" "webhook" {
  name            = "nodeapp-github-webhook"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = "${aws_codepipeline.nodeapp_pipeline.name}"

  authentication_configuration {
    secret_token = "${var.github_webhooks_token}"
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}



