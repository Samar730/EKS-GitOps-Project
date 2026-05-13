# RDS Subnet Group - defines which private subnets RDS can deploy into
resource "aws_db_subnet_group" "rds_private_subnets" {
    name = "${var.project_name}-rds-private-subnets"
    subnet_ids = var.private_subnet_ids

    tags = {
      Name = "${var.project_name}-rds-private-subnets"
    }
}

# RDS Instance
resource "aws_db_instance" "postgresql" {
  allocated_storage    = var.allocated_storage # disk space in gigabytes allocated to RDS instance for storing the database data
  db_name              = "memos"
  db_subnet_group_name = aws_db_subnet_group.rds_private_subnets.name
  engine               = "postgres"
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  skip_final_snapshot  = true
  vpc_security_group_ids = var.rds_sg_id 

  tags = {
    Name = "${var.project_name}-rds-db"
  }
}