#!/bin/bash

sudo yum -y update

# Install and run docker
sudo yum install -y docker
sudo service docker start
sudo service docker status

# Install docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
echo "Installed Docker compose"

# Save the docker-compose.yml
echo "Saving docker compose.yml"
echo '
version: "3.3"
services:
  master0:
    network_mode: host
    build:
      context: ./redisnode
      args:
        - REDIS_PORT=6079

  replica0:
    network_mode: host
    build:
      context: ./redisnode
      args:
        - REDIS_PORT=6080
    depends_on:
      - master0

  master1:
    network_mode: host
    build:
      context: ./redisnode
      args:
        - REDIS_PORT=6179
    
  replica1:
    network_mode: host
    build:
      context: ./redisnode
      args:
        - REDIS_PORT=6180
    depends_on:
      - master1

  master2:
    network_mode: host
    build:
      context: ./redisnode
      args:
        - REDIS_PORT=6279

  replica2:
    network_mode: host
    build:
      context: ./redisnode
      args:
        - REDIS_PORT=6280
    depends_on:
      - master2

  cluster-setup:
    network_mode: host
    build: ./cluster-setup
    depends_on:
      - master0
      - master1
      - master2
      - replica0
      - replica1
      - replica2
' > /home/ec2-user/docker-compose.yml
echo "Saved docker compose"

# Run the docker-compose.yml
sudo docker-compose -f /home/ec2-user/docker-compose.yml up -d
