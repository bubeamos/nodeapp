/* S3 Bucket For Artifacts  */
resource "aws_s3_bucket" "source" {
  bucket        = "${var.source_bucket}"
  acl           = "private"
  force_destroy = true
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
  name            = "nodeapp_github_webhook"
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



