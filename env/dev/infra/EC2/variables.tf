##################################################################################################################
# 00X_BG_Pipeline Variables
##################################################################################################################

variable "key_pair_name" {
  description = "Pipeline KeyPair Name"
  type        = string
  default     = "00X_BG_Pipeline"
}

# variable "key_pair_path" {
#   description = "Pipeline Key Pair Path"
#   type        = string
#   default     = "~/.ssh/jenkins_dev_pipeline_keys.pub"
# }

# variable "user_data_script_path" {
#   description = "User Data Script Path"
#   type        = string
#   default     = "/scripts/DevLab00X_Pipeline_Script.sh"
#   #default     = "${path.module}/scripts/DevLab00X_Pipeline_Script.sh"
# }

variable "ami_id" {
  description = "Pipeline AMI ID"
  type        = string
  default     = "ami_0e56583ebfdfc098f"
}

variable "instance_type" {
  description = "Pipeline Instance Type"
  type        = string
  default     = "t2.small"
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
  default     = "DevLab00X_BG_Instance_Profile"
}

variable "security_groups_ingress" {
  description = "value"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "security_groups_egress" {
  description = "value"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "_1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "tags" {
  description = "Tag For The Jenkins Instance"
  type        = map(string)
  default = {
    "name"        = "00x_BG_PIPELINE"
    "environment" = "Dev"
  }
}