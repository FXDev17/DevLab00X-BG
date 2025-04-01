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
# checkov:skip=CKV_AWS_126:Detailed monitoring NOT required for personal project
resource "aws_instance" "BG_Pipeline" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  ebs_optimized          = var.ebs_optimized
  key_name               = aws_key_pair.BG_Pipeline_KeyPair.key_name
  vpc_security_group_ids = [aws_security_group.BG_Pipeline_SG.id]
  iam_instance_profile   = aws_iam_instance_profile.BG_Pipeline_IProfile.name
  user_data              = file("${path.module}/scripts/jenkins-pipeline-bootstrap.sh")
  monitoring             = var.monitoring
  tags                   = var.tags

  root_block_device {
    encrypted = var.root_block_device_encryption
  }

  metadata_options {
    http_endpoint = var.http_endpoint
    http_tokens   = var.http_tokens
  }

  security_groups = [ 
    aws_security_group.BG_Pipeline_SG_In.name,
    aws_security_group.BG_Pipeline_SG_Out.name
    
   ]
}

# Creating Security Groups
# checkov:skip=CCKV_AWS_24:Dev Projects No Need To Restrict
resource "aws_security_group" "BG_Pipeline_SG_In" {
  name_prefix = "BG_Pipeline_SG_In"
  description = "Ingress rules for BG Pipeline"

  dynamic "ingress" {
    for_each = var.security_groups_ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }
}

# Creating Security Groups
resource "aws_security_group" "BG_Pipeline_SG_Out" {
  name_prefix = "BG_Pipeline_SG_Out"
  description = "Egress rules for BG Pipeline"

  dynamic "egress" {
    for_each = var.security_groups_egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
    }
  }
}

# Creating IAM Instance Profile
resource "aws_iam_instance_profile" "BG_Pipeline_IProfile" {
  name_prefix = "BG_Pipeline_IProfile"
  role        = module.bg_pipeline_role_import.bg_pipeline_role
}