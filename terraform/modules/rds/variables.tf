variable "project_name" {
    type = string
}

variable "private_subnet_ids" {
    type        = list(string)
  description = "Private Subnet IDs"
}

variable "allocated_storage" {
    type = number
    description = "disk space in gigabytes allocated to RDS instance for storing the database data."
    default = 20
}

variable "engine_version" {
    type = string
    default = "16."
}

variable "instance_class" {
    type = string
    default = "db.t3.micro"
}

variable "username" {
    type = string
}

variable "password" {
    type = string
}

variable "rds_sg_id" {
  type        = list(string)
  description = "Security Group ID for RDS"
}