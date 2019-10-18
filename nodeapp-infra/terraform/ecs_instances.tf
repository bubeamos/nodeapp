resource "aws_launch_configuration" "container_instances_launch_config" {
    name                        = "container_instances_launch_config"
    image_id                    = "${var.image_id}"
    instance_type               = "${var.instance_type}"
    iam_instance_profile        = "${aws_iam_instance_profile.ecs-instance-profile.id}"

    root_block_device {
      volume_type = "standard"
      volume_size = 50
      delete_on_termination = true
    }

    lifecycle {
      create_before_destroy = true
    }

    security_groups             = [aws_security_group.ecs_container_instance.id]

    associate_public_ip_address = "false"
    key_name                    = "${var.ecs_key_pair_name}"
    user_data                   = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=${aws_ecs_cluster.nodeapp-cluster.name} >> /etc/ecs/ecs.config
                                  EOF
}

# ECs Container Instances in a Private Subnet
resource "aws_autoscaling_group" "ecs-autoscaling-group" {
    name                        = "ecs-autoscaling-group"
    max_size                    = "${var.max_instance_size}"
    min_size                    = "${var.min_instance_size}"
    desired_capacity            = "${var.desired_capacity}"
    vpc_zone_identifier         = aws_subnet.private.*.id
    launch_configuration        = "${aws_launch_configuration.container_instances_launch_config.name}"

    tag {
    key                 = "name"
    value               = "nodeapp-instance"
    propagate_at_launch = true
  }

   tag {
    key                 = "auto-delete"
    value               = "no"
    propagate_at_launch = true
  }
  }

