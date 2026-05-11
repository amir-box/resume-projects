variable "project_name" {
  type = string
}

variable "database_name" {
  type = string
}

variable "master_username" {
  type = string
}

variable "primary_vpc_id" {
  type = string
}

variable "secondary_vpc_id" {
  type = string
}

variable "primary_db_subnets" {
  type = list(string)
}

variable "secondary_db_subnets" {
  type = list(string)
}