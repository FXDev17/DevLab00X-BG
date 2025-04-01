# Defining Policy For EC2 to Use to Assume Role
data "aws_iam_policy_document" "BG_Pipeline_Assume_Role_Policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Defining the IAM Role
resource "aws_iam_role" "BG_Pipeline_Role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.BG_Pipeline_Assume_Role_Policy.json
}

# Defininf the IAM Policy
data "aws_iam_policy_document" "BG_Pipeline_Permissions_Policy" {
  statement {
    actions = [
      # EC2 Permissions
      "ec2:DescribeInstances",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:ImportKeyPair",
      "ec2:CreateSecurityGroup",

      # S3 Permissions
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",

      # IAM Permissions
      "iam:CreateRole",
      "iam:CreatePolicy"
    ]
    resources = [
      # S3 resources
      "arn:aws:s3:::devlab00-logging",
      "arn:aws:s3:::devlab00-logging/*",

      # EC2 resources
      "arn:aws:ec2:eu-west-1:817520395860:key-pair/*",
      "arn:aws:ec2:eu-west-1:817520395860:security-group/*",

      # IAM resources
      "arn:aws:iam::817520395860:role/BG_Pipeline_Role",
      "arn:aws:iam::817520395860:policy/BG_Pipeline_Policy"
    
    ]
    condition {
      test = "StringEquals"
      variable = "ec2:ResourceTag/ManagedBy"
      values = [ "jenkins" ]
    }
  }
}

# Defining IAM Policy
resource "aws_iam_policy" "BG_Pipeline_Policy" {
  name        = var.aws_iam_policy_name
  description = var.aws_iam_policy_description
  policy      = data.aws_iam_policy_document.BG_Pipeline_Permissions_Policy.json
}

# Attaching Policy To Role
resource "aws_iam_role_policy_attachment" "BG_Pipeline_Role_Attachment" {
  role       = aws_iam_role.BG_Pipeline_Role.name
  policy_arn = aws_iam_policy.BG_Pipeline_Policy.arn
}