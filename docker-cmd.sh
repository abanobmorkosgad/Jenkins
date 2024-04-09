#!/usr/bin/env bash

export IMAGE="abanobmorkos10/java-maven:1.1.12-25"
echo $IMAGE
# sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o docker-compose
# sudo mv docker-compose /usr/local/bin
# sudo chmod +x /usr/local/bin/docker-compose
# sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo docker-compose -f docker-compose.yaml up --detach