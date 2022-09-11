variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}
variable "vpc_tags" {
    default = "VPC-NODE"
}
variable "subnets" {
    default = ["10.0","10.0"] 
}
variable "subnet_tag" {
    default = ["subnet-1","subnet-2"]
}
variable "igw" {
    default = "Internet Gateway - Public Subnet"
}
variable "az" {
    default = ["us-east-1a", "us-east-1b"]
}
variable "ec2_ami" {
    default = "ami-05fa00d4c63e32376"
}
variable "vpc_cidr_sg" {
    default = ["0.0.0.0/0"]
  
}

variable "alb-sg" {
    default = ["0.0.0.0/0"] 
}
variable "ecs-service-role-arn" {
    default = "ecs-cluster-role"
}