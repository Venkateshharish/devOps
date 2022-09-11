#!/bin/bash
#!/bin/bash
sudo su -
echo ECS_CLUSTER=ecs-cluster-node-app >> /etc/ecs/ecs.config
cat /etc/ecs/ecs.config | grep "ECS_CLUSTER"

# Update all packages
sudo amazon-linux-extras disable docker
sudo amazon-linux-extras install -y ecs
sudo systemctl stop ecs
sudo systemctl start ecs
sudo systemctl restart docker


