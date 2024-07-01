resource "aws_cloudwatch_event_rule" "this" {

  name          = var.event_rule.name
  description   = var.event_rule.description
  event_pattern = var.event_rule.event_pattern
}

resource "aws_cloudwatch_event_target" "this" {

  for_each = { for target in var.event_rule.event_targets : target.name => target }

  arn       = each.value.arn
  rule      = aws_cloudwatch_event_rule.this.id
  target_id = each.value.target_id
  role_arn  = each.value.role_arn

  dynamic "input_transformer" {
    for_each = each.value.input_transformer != null ? [each.value.input_transformer] : []
    content {
      input_paths    = input_transformer.value.input_paths
      input_template = input_transformer.value.input_template
    }
  }
}
