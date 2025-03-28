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
      "ec2:DescribeInstances",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = ["*"]
  }
}

# Defining IAM Policy
resource "aws_iam_policy" "BG_Pipeline_Policy" {
  name        = var.aws_iam_policy_name
  description = var.aws_iam_policy_description
  policy      = data.aws_iam_policy_document.BG_Pipeline_Assume_Role_Policy.json
}

# Attaching Policy To Role
resource "aws_iam_role_policy_attachment" "BG_Pipeline_Role_Attachment" {
  role       = aws_iam_role.BG_Pipeline_Role.name
  policy_arn = aws_iam_policy.BG_Pipeline_Policy.arn
}