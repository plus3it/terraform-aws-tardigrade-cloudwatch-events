# terraform-aws-tardigrade-cloudwatch-events
Module to manage cloudwatch events and targets


<!-- BEGIN TFDOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_rule"></a> [cloudwatch\_rule](#input\_cloudwatch\_rule) | Object of input configs for cloudwatch event rules | <pre>list(object({<br>    event_rule = object({<br>      name          = string<br>      description   = string<br>      event_pattern = string<br>    })<br>    event_target = object({<br>      event_name       = string<br>      event_target_id  = optional(string)<br>      event_target_arn = string<br>      role_arn         = string<br>      input_transformer = object({<br>        input_paths = map(string)<br>      })<br>      input_template = string<br>    })<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.

<!-- END TFDOCS -->
