resource "aws_ecs_task_definition" "node-task" {
    family = "NodeJSApp"
    container_definitions = "${data.template_file.task_definition.rendered}"
    network_mode = "bridge"
    memory = "240"
    cpu = "1024"
    requires_compatibilities = [ "EC2" ]
}

data "template_file" "task_definition" {
  template = file("/var/lib/jenkins/workspace/node-app-docker-ecr/terraform/ecs/task-definition.json")
}

output "task-def" {
  value = aws_ecs_task_definition.node-task.arn
  
}

   
