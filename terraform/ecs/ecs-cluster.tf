resource "aws_ecs_cluster" "node-app" {
    name = "ecs-cluster-node-app"
}

output "cluster-name" {
    value = aws_ecs_cluster.node-app.id
  
}