variable "event_rule" {
  description = "Object of input configs for the CloudWatch Event Rule"
  type = object({
    name           = string
    description    = optional(string)
    event_pattern  = optional(string)
    event_bus_name = optional(string)

    event_targets = optional(list(object({
      name = string
      arn  = string

      event_bus_name = optional(string)
      role_arn       = optional(string)
      target_id      = optional(string)

      dead_letter_config = optional(object({
        arn = string
      }))

      input_transformer = optional(object({
        input_paths    = optional(map(string))
        input_template = string
      }))
    })), [])
  })
}
