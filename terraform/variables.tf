variable "aws_region" {
  default = "eu-west-1"
}

variable "aws_account" {
  default = "477807511636"
}

variable "ORIENTDB_ROOT_PASSWORD" {
  type = string
}

variable "paloma_ecs_cluster_name" {
  default = "paloma"
}
