resource "random_string" "this" {
  length  = 8
  upper   = false
  special = false
  numeric = false
}

module "cloudwatch" {
  source = "../../"

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
    event_targets = [
      {
        name      = "target1"
        target_id = "Id0d05d630-096c-4f51-af8c-f5c07daab1ee"
        arn       = "arn:${data.aws_partition.current.partition}:codebuild:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:project/${random_string.this.result}"
        role_arn  = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/service-role/Amazon_EventBridge_Invoke_CodeBuild_1840626416"
        input_transformer = {
          input_paths = {
            destination-version = "$.detail.destinationReference"
          }
          input_template = "{\"destinationVersion\": <destination-version>}"
        }
      },
      {
        name      = "target2"
        target_id = "Id0d05d630-096c-4f51-af8c-f5c07daab1ee"
        arn       = "arn:${data.aws_partition.current.partition}:codebuild:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:project/${random_string.this.result}"
        role_arn  = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/service-role/Amazon_EventBridge_Invoke_CodeBuild_1840626416"
        dead_letter_config = {
          arn = "arn:${data.aws_partition.current.partition}:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${random_string.this.result}"
        }
      }
    ]
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}
