variable "cloudwatch_rule" {
  description = "Object of input configs for cloudwatch event rules"
  type = list(object({
    event_rule = object({
      name          = string
      description   = string
      event_pattern = string
    })
    event_target = object({
      event_name       = string
      event_target_id  = optional(string)
      event_target_arn = string
      role_arn         = string
      input_transformer = object({
        input_paths = map(string)
      })
      input_template = string
    })
  }))
}
