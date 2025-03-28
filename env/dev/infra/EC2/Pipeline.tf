# Importing IAM Module Role Output
module "bg_pipeline_role_import" {
  source = "../IAM"
}

# Creating KeyPair
resource "aws_key_pair" "BG_Pipeline_KeyPair" {
  key_name   = var.key_pair_name
  public_key = file("~/.ssh/jenkins-dev-pipeline-keys.pub")
}

# Creating Jenkins Pipeline
resource "aws_instance" "BG_Pipeline" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.BG_Pipeline_KeyPair.key_name
  vpc_security_group_ids = [aws_security_group.BG_Pipeline_SG.id]
  user_data              = "${path.module}/scripts/DevLab00X_Pipeline_Script.sh"
  iam_instance_profile   = aws_iam_instance_profile.BG_Pipeline_IProfile.name
  tags                   = var.tags
}

# Creating Security Groups
resource "aws_security_group" "BG_Pipeline_SG" {
  name_prefix = "BG_Pipeline_SG"

  dynamic "ingress" {
    for_each = var.security_groups_ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.security_groups_ingress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}

# Creating IAM Instance Profile
resource "aws_iam_instance_profile" "BG_Pipeline_IProfile" {
  name_prefix = "BG_Pipeline_IProfile"
  role        = module.bg_pipeline_role_import.bg_pipeline_role
}