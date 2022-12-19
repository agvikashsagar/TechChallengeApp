[
  {
    "name": "cb-app",
    "image": "${app_image}",
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
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ],
    "environment": [
      {
        "name": "VTT_DBHOST",
        "value": "${db_endpoint}"
      },
      {
        "name": "VTT_LISTENHOST",
        "value": "0.0.0.0"
      },
      {
        "name": "VTT_DBTYPE",
        "value": "postgres"
      }
    ]
  }
]