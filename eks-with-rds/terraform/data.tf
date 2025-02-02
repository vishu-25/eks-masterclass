# Fetch the existing VPC
data "aws_vpc" "eks_vpc" {
  filter {
    name   = "tag:Name"
    values = ["eksctl-eksdemo1-cluster/VPC"]
  }
}

# Fetch the existing subnets in the VPC
data "aws_subnets" "eks_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks_vpc.id]
  }
}