variable "cluster_name" {
  description = "The name to use for all the cluster resources"
}

variable "server_port" {
  description = "The port the servier will use for HTTP requests"
  default     = 8080
}

variable "database_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
}

variable "database_remote_state_key" {
  description = "The path for the database's remote state in S3"
}
