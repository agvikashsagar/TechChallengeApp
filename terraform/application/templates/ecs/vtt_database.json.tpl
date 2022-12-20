[
  {
    "name": "cb-database",
    "image": "${db_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/cb-app",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${db_port},
        "hostPort": ${db_port}
      }
    ],
    "environment": [
      {
        "name": "POSTGRES_PASSWORD",
        "value": "changeme"
      }
    ]
  }
]