variable "group_name" {
  description = "The name of the IAM group"
  type = string
    default     = "developers"
}

variable "user_name_1" {
  description = "The name of the first IAM user"
  type = string
    default     = "developer_1"
}

variable "user_name_2" {
  description = "The name of the second IAM user"
  type = string
    default     = "developer_2"
}