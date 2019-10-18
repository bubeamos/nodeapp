# variables.tf

variable "aws_region" {
  description = "The AWS region where resources are created in"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "myEcsTaskExecutionRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 3000
}

variable "doc_db_port" {
  description = "Document DB Port"
  default     = 27017
}

variable "redis_port" {
  description = "Redis Port"
  default     = 6379
}

variable "ephemeral_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 65535
}

variable "app_count" {
  description = "Number of ECS tasks to run in the service"
  default     = 2
}

variable "health_check_path" {
  default = "/login"
}

variable "nodeapp_cpu" {
  description = "Nodeapp Container instance CPU units to provision "
  default     = "1024"
}

variable "nodeapp_memory" {
  description = "Nodeapp Container memory Reservation(in MiB)"
  default     = "2048"
}

variable "ecs_key_pair_name" {
  description = "EC2 instance key pair name"
}

variable "max_instance_size" {
  description = "Maximum number of instances in the cluster"
  default     = 3
}

variable "min_instance_size" {
  description = "Minimum number of instances in the cluster"
  default     = 1
}

variable "desired_capacity" {
  description = "Desired number of instances in the cluster"
  default     = 2
}

variable "image_id" {
  description = "ECS Optimized AMI To Provision ECS Container Instances"
  default     = "ami-0ab0050d945a2d795"
}

variable "instance_type" {
  description = "Instance Type For ECS Container Instance"
  default     = "t2.large"
}

variable "name" {
  default = "nodeapp"
}

variable "docdb_instance_class" {
  description = "Document DB Instance Class"
  default = "db.r4.large"
}

variable "docdb_password" {
  description = "Document DB Password"  
}
variable "aws_route53_zone" {
  description = "Hosted Zone Where DNS Record Should Be Created"
    
}

variable "aws_account_id" {
  description = "Your aws account ID that can be passed to parameter arn"
}

variable "max_healthy_percent" {
  description = "Upper Limit for number of tasks during deployment"
  default = 150
}

variable "min_healthy_percent" {
  description = "Lower Limit for number of tasks during deployment"
  default = 50
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


variable "private_subnet_ids" {
  type        = list(string)
  description = "Private Subnets For Redis and DocumentDB"
}

variable "dns_record" {
  type        = string
  description = "DNS Name that will be mapped to the ALB"
}


variable "acm_arn" {
  type        = string
  description = "ARN Of the ACM To Use"
}

