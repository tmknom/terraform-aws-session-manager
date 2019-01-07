#!/bin/sh

# Install docker
amazon-linux-extras install -y docker
systemctl start docker
systemctl enable docker

# Install docker-compose
DOCKER_COMPOSE_VERSION=1.23.2
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
