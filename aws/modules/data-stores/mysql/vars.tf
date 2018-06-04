variable "database_admin_password" {
  description = "The admin password for the database"
  default     = ""
}

variable "database_admin_username" {
  description = "The admin username for the database"
}

variable "database_name" {
  description = "The database name"
}

variable "database_allocated_storage" {
  description = "The allocated storage for the database"
}

variable "database_instance_type" {
  description = "The type of EC2 instance to run the database on"
}
