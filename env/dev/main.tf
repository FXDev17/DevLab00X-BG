module "dev" {
  source = "./dev"
}

module "ec2" {
  source = "./infra/EC2"
}

module "iam" {
  source = "./infra/IAM"
}