resource "aws_docdb_subnet_group" "nodeapp_docdb_subnet" {
  name       = "tf-${var.name}"
  subnet_ids = var.private_subnet_ids
}

resource "aws_docdb_cluster_instance" "nodeapp_docdb_instance" {
  count              = 1
  identifier         = "tf-${var.name}-${count.index}"
  cluster_identifier = "${aws_docdb_cluster.nodeapp_docdb_cluster.id}"
  instance_class     = "${var.docdb_instance_class}"
}

resource "aws_docdb_cluster" "nodeapp_docdb_cluster" {
  skip_final_snapshot     = true
  db_subnet_group_name    = "${aws_docdb_subnet_group.nodeapp_docdb_subnet.name}"
  cluster_identifier      = "tf-${var.name}"
  engine                  = "docdb"
  master_username         = "tf_${replace(var.name, "-", "_")}_admin"
  master_password         = "${var.docdb_password}"
  db_cluster_parameter_group_name = "${aws_docdb_cluster_parameter_group.nodeapp_paramter_group.name}"
  vpc_security_group_ids = [var.docdb_security_groups]
}



resource "aws_docdb_cluster_parameter_group" "nodeapp_paramter_group" {
  family = "docdb3.6"
  name = "tf-${var.name}"

  parameter {
    name  = "tls"
    value = "disabled"
  }
}

# Module To Launch Redis Cluster 
module "redis" {
  source                     = "git::https://github.com/cloudposse/terraform-aws-elasticache-redis.git?ref=tags/0.13.0"
  availability_zones         = var.availability_zones
  namespace                  = var.namespace
  stage                      = var.stage
  name                       = var.name
  zone_id                    = var.aws_route53_zone
  vpc_id                     = var.vpc_id
  security_groups            = [var.redis_security_groups]
  subnets                    = var.private_subnet_ids
  cluster_size               = var.cluster_size
  instance_type              = var.redis_instance_type
  engine_version             = var.engine_version
  family                     = var.family

  parameter = [
    {
      name  = "notify-keyspace-events"
      value = "lK"
    }
  ]
}
