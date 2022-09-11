module "iam" {
    source = "./iam"
}

module "ecs" {
  source = "./ecs" 
  
}
//VPC Creation
resource "aws_vpc" "node-vpc" {
    cidr_block = var.vpc_cidr_block
    instance_tenancy = "default"
    enable_dns_hostnames = "true"
    tags = {
      "Name" = var.vpc_tags
    }
}

resource "aws_security_group" "ecs-vpc-sg" {
  vpc_id = aws_vpc.node-vpc.id
  name = "ecs-vpc-sg"
  description = "sg for ec2 to allow 8080 port to connect node app"

  ingress {
    cidr_blocks = var.vpc_cidr_sg
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    }
  ingress {
    cidr_blocks = var.vpc_cidr_sg
    from_port = 80
    to_port = 80
    protocol = "tcp"
    }
  ingress {
    cidr_blocks = var.vpc_cidr_sg
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    }
  ingress {
      cidr_blocks = var.vpc_cidr_sg
      from_port = 22
      to_port = 22
      protocol = "tcp"
    }
  egress {
    cidr_blocks = var.vpc_cidr_sg
    from_port = 0
    to_port = 65535
    protocol = "tcp"
  }
  lifecycle {
    create_before_destroy = false
  } 
}

resource "aws_security_group" "node-app-alb-sg" {
  vpc_id = aws_vpc.node-vpc.id
  name = "node-app-alb-sg"
  description = "loadbalancer to talk with ecs instances"

  ingress {
    cidr_blocks = var.alb-sg
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    }
  ingress {
    cidr_blocks = var.alb-sg
    from_port = 80
    to_port = 80
    protocol = "tcp"
    }
  ingress {
      cidr_blocks = var.alb-sg
      from_port = 6868
      to_port = 6868
      protocol = "tcp"
    }
  egress {
    cidr_blocks = var.alb-sg
    from_port = 0
    to_port = 65535
    protocol = "tcp"
  }
  lifecycle {
    create_before_destroy = false
  } 
}

output "alb-sg-name" {
  value = aws_security_group.node-app-alb-sg.id
}


output "sg" {
    value = aws_security_group.ecs-vpc-sg.id
}
//Subnet Creation
resource "aws_subnet" "subnets_2" {
  count = 2
  vpc_id = aws_vpc.node-vpc.id
  cidr_block = join(".", [var.subnets[count.index], count.index, "0/24"])
  availability_zone = var.az[count.index]
  map_public_ip_on_launch = "true"
  tags = {
    "Name" = var.subnet_tag[count.index]
  }
}

resource "aws_internet_gateway" "int_gtway" {
  vpc_id = aws_vpc.node-vpc.id
  tags = {
    "Name" = var.igw
  }
}

resource "aws_route_table" "rtb"{
  vpc_id = aws_vpc.node-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.int_gtway.id
  }
}
resource "aws_route_table_association" "rtb_association" {
  count = 2
  subnet_id = element(aws_subnet.subnets_2.*.id,count.index)
  route_table_id = aws_route_table.rtb.id
}

resource "aws_instance" "ecs_instance" {
    ami = var.ec2_ami 
    instance_type = "t2.micro"
    subnet_id = element(aws_subnet.subnets_2.*.id,0)
    iam_instance_profile = "${module.iam.ecs-instance-profile-name}"
    vpc_security_group_ids = [aws_security_group.ecs-vpc-sg.id]
    user_data = "${data.template_file.userdata.rendered}"
    tags = {
      "Name" = "ecs-ec2-instance"
    }
}

data "template_file" "userdata" {
  template = "${file("./userdata.tpl")}"
}

resource "aws_alb" "node-app-alb" {
  name = "node-app-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.node-app-alb-sg.id]
  subnets = [for subnet in aws_subnet.subnets_2 : subnet.id]
  tags = {
    "Name" = "node-app-alb"
  }
}

resource "aws_lb_target_group" "node-app-tg" {
  name = "node-app-alb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.node-vpc.id
}

output "alb-tg" {
  value = aws_lb_target_group.node-app-tg.arn  
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
  target_id = aws_instance.ecs_instance.id
  port = 80 
}

################################################################################################################
resource "aws_ecs_service" "node-app-service" {
cluster = "${module.ecs.cluster-name}"
//iam_role = aws_iam_role.ecs-task-role.arn
desired_count = 1
/*ordered_placement_strategy {
  type = "spread"
  field = "instanceId"
}*/
launch_type = "EC2"
name = "node-app-service"
task_definition = "${module.ecs.task-def}"
load_balancer {
  container_name = "node-task"
  container_port = 8080
  target_group_arn = aws_lb_target_group.node-app-tg.arn
}

/*network_configuration {
  security_groups = [aws_security_group.node-app-alb-sg.id]
  subnets = [for subnet in aws_subnet.subnets_2 : subnet.id]
 }*/
 depends_on = [
   aws_alb_listener.node-app-alb-tg-listner
 ]
}


//RDS Database Creation

/*resource "aws_db_subnet_group" "vpcc" {
  name       = "main"
  subnet_ids = [for subnet in aws_subnet.subnets_2 : subnet.id]
}

resource "aws_db_instance" "node-js-db" {
  allocated_storage = 10
  engine = "mysql"
  engine_version = "8.0.28"
  instance_class = "db.t2.micro"
  db_name = "tutorials"
  username = "root"
  password = "12345678"
  publicly_accessible = "true"
  vpc_security_group_ids = [aws_security_group.ecs-vpc-sg.id]
  db_subnet_group_name = aws_db_subnet_group.vpcc.name
  skip_final_snapshot = true
}*/


/*resource "aws_iam_role" "ecs-task-role" {
  name = "ECStoAccessEc2" 
  assume_role_policy = data.aws_iam_policy_document.ecs-role.json
}

data "aws_iam_policy_document" "ecs-role" {
  statement {
    actions = [ "sts:AssumeRole" ]
    principals {
      type = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}
resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
  role = aws_iam_role.ecs-task-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}*/
