terraform {
  backend "s3" {
    bucket         = "sanilk.xyz.redis-cluster-bucket"
    key            = "tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "single-public-subnet" {
  source = "./modules/single-public-subnet"
}

module "ec2-instance" {
  source = "./modules/ec2-instance"

  user_data = file("./server-userdata.sh")
  subnet_id = module.single-public-subnet.subnet_id
  vpc_id = module.single-public-subnet.vpc_id
}

resource "aws_ecr_repository" "redis-node_repository" {
  name                 = "redis-node"
}

resource "aws_ecr_repository" "cluster-setup_repository" {
  name                 = "cluster-setup"
}