resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/ecs/techchallenge2/frontend"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/techchallenge2/backend"
  retention_in_days = 7
}