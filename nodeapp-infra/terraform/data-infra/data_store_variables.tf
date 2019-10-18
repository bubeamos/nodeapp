variable "aws_region" {
  description = "The AWS region where resources are created in"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zone IDs"
}

variable "namespace" {
  type        = string
  description = "Namespace"
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "cluster_size" {
  type        = number
  description = "Count of nodes in cluster"
}

variable "redis_instance_type" {
  type        = string
  description = "Elastic cache instance type"
}

variable "family" {
  type        = string
  description = "Redis family"
}

variable "engine_version" {
  type        = string
  description = "Redis engine version"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID For Redis"
}

variable "redis_security_groups" {
  type        = string
  description = "Security Group for Redis"
}

variable "docdb_security_groups" {
  type        = string
  description = "Security Group for Doc DB"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private Subnets For Redis and DocumentDB"
}

variable "aws_route53_zone" {
  description = "Hosted Zone Where DNS Record Should Be Created"
    
}

variable "docdb_instance_class" {
  description = "Document DB Instance Class"
}

variable "name" {
  default = "nodeapp"
}

variable "docdb_password" {
  description = "Document DB Password"  
}