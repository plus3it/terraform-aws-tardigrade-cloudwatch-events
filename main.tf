resource "aws_cloudwatch_event_rule" "this" {
  for_each = { for item in var.cloudwatch_rule : item.event_rule.name => item }

  name          = each.value.event_rule.name
  description   = each.value.event_rule.description
  event_pattern = each.value.event_rule.event_pattern
}


resource "aws_cloudwatch_event_target" "this" {
  for_each = { for item in var.cloudwatch_rule : item.event_target.event_name => item }

  arn       = each.value.event_target.event_target_arn
  rule      = each.value.event_target.event_name
  target_id = each.value.event_target.event_target_id
  role_arn  = each.value.event_target.role_arn

  input_transformer {
    input_paths = each.value.event_target.input_transformer.input_paths

    input_template = each.value.event_target.input_template
  }
  depends_on = [aws_cloudwatch_event_rule.this]
}
