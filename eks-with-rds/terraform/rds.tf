# Create a Security Group for RDS
resource "aws_security_group" "eks_rds_sg" {
  name        = "eks_rds_db_sg"
  description = "Allow access for RDS Database on Port 3306"
  vpc_id      = data.aws_vpc.eks_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open for testing, restrict in production
    description = "Allow access for RDS Database on Port 3306"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a DB Subnet Group
resource "aws_db_subnet_group" "eks_rds_subnetgroup" {
  name       = "eks-rds-db-subnetgroup"
  description = "EKS RDS DB Subnet Group"
  subnet_ids = data.aws_subnets.eks_subnets.ids
}

# Create RDS Database
resource "aws_db_instance" "usermgmt_db" {
  identifier           = "usermgmtdb"
  engine              = "mysql"
  engine_version      = "8.0.40"
  instance_class      = "db.t3.micro" # Free-tier eligible
  allocated_storage   = 20
  storage_type        = "gp2"
  username           = "dbadmin"
  password           = "dbpassword11"
  publicly_accessible = true
  vpc_security_group_ids = [aws_security_group.eks_rds_sg.id]
  db_subnet_group_name  = aws_db_subnet_group.eks_rds_subnetgroup.name
  skip_final_snapshot   = true
}
