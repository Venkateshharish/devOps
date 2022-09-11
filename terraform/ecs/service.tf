/*resource "aws_alb" "node-app-alb" {
  name = "node-app-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.node-app-alb-sg.id]
  subnets = ["subnet-0de8dc24696e1a470", "subnet-0c4fa14acdca6bda1"]
  tags = {
    "Name" = "node-app-alb"
  }
}
resource "aws_lb_target_group" "node-app-tg" {
  name = "node-app-alb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = "vpc-0da7687d5518ca175"
}

resource "aws_alb_listener" "node-app-alb-tg-listner" {
  load_balancer_arn = aws_alb.node-app-alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.node-app-tg.arn
  }
}
resource "aws_lb_target_group_attachment" "node-app-instance-attach" {
  target_group_arn = aws_lb_target_group.node-app-tg.arn
  target_id = data.local_file.id
  port = 80 
}*/