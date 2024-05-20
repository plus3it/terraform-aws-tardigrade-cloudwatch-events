resource "random_string" "this" {
  length  = 8
  upper   = false
  special = false
  numeric = false
}

module "cloudwatch" {
  source = "../"

  cloudwatch_rule = [
    {
      event_rule = {
        name        = "event1"
        description = random_string.this.result
        event_pattern = jsonencode({
          source      = ["aws.codecommit"],
          detail-type = ["${random_string.this.result}"],
          account     = [data.aws_caller_identity.current.account_id],
          region      = [data.aws_region.current.name],
          resources   = ["arn:${data.aws_partition.current.partition}:codecommit:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${random_string.this.result}"],
          detail = {
            destinationReference = ["${random_string.this.result}"],
            isMerged             = ["${random_string.this.result}"],
            pullRequestStatus    = ["${random_string.this.result}"],
          }
        })
      }
      event_target = {
        event_name       = "event1"
        event_target_id  = "Id0d05d630-096c-4f51-af8c-f5c07daab1ee"
        event_target_arn = "arn:${data.aws_partition.current.partition}:codebuild:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:project/${random_string.this.result}"
        role_arn         = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/service-role/Amazon_EventBridge_Invoke_CodeBuild_1840626416"
        input_transformer = {
          input_paths = {
            destination-version = "$.detail.destinationReference"
          }

        }
        input_template = "{\"destinationVersion\": <destination-version>}"
      }
    },
    {
      event_rule = {
        name        = "event2"
        description = "Triggers codebuild np-terraform-review-flow-ci when pr is created or updated in the repo"
        event_pattern = jsonencode({
          source      = ["aws.codecommit"],
          detail-type = ["CodeCommit Pull Request State Change"],
          account     = [data.aws_caller_identity.current.account_id],
          region      = [data.aws_region.current.name],
          resources   = ["arn:${data.aws_partition.current.partition}:codecommit:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:np-baseline-terraform"],
          detail = {
            isMerged          = ["False"],
            pullRequestStatus = ["Open"],
          }
        })
      }
      event_target = {
        event_name       = "event2"
        event_target_id  = "Id31dda6bc-12b5-4864-b050-45d851b2bdbc"
        event_target_arn = "arn:${data.aws_partition.current.partition}:codebuild:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:project/np-terraform-review-flow-ci"
        role_arn         = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/service-role/Amazon_EventBridge_Invoke_CodeBuild_826459662"
        input_transformer = {
          input_paths = {
            source-version = "$.detail.sourceReference"
          }
        }
        input_template = "{\"sourceVersion\": <source-version>}"
      }
    }
  ]
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}
