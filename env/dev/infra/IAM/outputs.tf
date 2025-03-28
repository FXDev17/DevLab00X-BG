# Output the IAM role's name
output "bg_pipeline_role" {
  value       = aws_iam_role.BG_Pipeline_Role.name
  description = "The name of the Jenkins Dev Pipeline IAM role"
  depends_on = [ aws_iam_role.BG_Pipeline_Role ]
}