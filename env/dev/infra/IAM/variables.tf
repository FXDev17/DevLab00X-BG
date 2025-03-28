variable "role_name" {
  description = "BG_Pipeline Role Name"
  type        = string
  default     = "BG_Pipeline_Role"
}

variable "aws_iam_policy_name" {
  description = "BG_Pipeline Role Policy"
  type        = string
  default     = "BG_Pipeline_Policy"
}

variable "aws_iam_policy_description" {
  description = "BG_Pipeline Role Policy Description"
  type        = string
  default     = "BG_Pipeline_Role_Policy"
}