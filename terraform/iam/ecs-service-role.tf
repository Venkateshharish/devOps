/*resource "aws_iam_role" "ecs-task-execution-role" {
    name                = "ecs-task-execution-role"
    path                = "/"
    assume_role_policy  = "${data.aws_iam_policy_document.ecs-task-execution-role.json}"
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role" {
    role       = "${aws_iam_role.ecs-task-execution-role.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecs-task-execution-role" {
    statement {
        sid = ""
        effect = "Allow"
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ecs-tasks.amazonaws.com"]
        }
    }
}

output "service-role-arn" {
   value = "${aws_iam_role.ecs-task-execution-role.arn}"
}*/