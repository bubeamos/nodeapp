[
  {
    "name": "nodeapp-service",
    "image": "${app_image}",
    "cpu": ${nodeapp_cpu},
    "memoryReservation": ${nodeapp_memory},
    "networkMode": "awsvpc",
    "secrets": [{
      "name": "MONGODB_URI",
      "valueFrom": "arn:aws:ssm:${aws_region}:${aws_account_id}:parameter/mongo_uri"
    },
    {

      "name": "REDIS_URI",
      "valueFrom": "arn:aws:ssm:${aws_region}:${aws_account_id}:parameter/redis_uri"
    },
    {

      "name": "FACEBOOK_ID",
      "valueFrom": "arn:aws:ssm:${aws_region}:${aws_account_id}:parameter/facebook_id"
    },
    {

      "name": "FACEBOOK_SECRET",
      "valueFrom": "arn:aws:ssm:${aws_region}:${aws_account_id}:parameter/facebook_secret"
    },
    {

      "name": "SESSION_SECRET",
      "valueFrom": "arn:aws:ssm:${aws_region}:${aws_account_id}:parameter/session_secret"
    }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/nodeapp",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "cpu": 1,
    "portMappings": [
      {
        "containerPort": ${app_port},
        "protocol": "tcp"
      }
    ],
    "environment": [
        {
          "name": "NODE_ENV",
          "value": "production"
        }
      ]
  }


] 
