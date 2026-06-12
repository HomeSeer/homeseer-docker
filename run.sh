#!/bin/bash -e

##############################################
# HOMESEER (V4) LINUX - DOCKER RUN CONTAINER
##############################################
docker run \
       --interactive \
       --tty \
       --name homeseer \
       --volume /usr/local/homeseer:/homeseer \
       --volume /var/run/docker.sock:/var/run/docker.sock \
       --publish 80:80 \
       --publish 1883:1883 \
       --publish 10200:10200 \
       --publish 10300:10300 \
       --publish 10401:10401 \
       --publish 11000:11000 \
       --env TZ=America/New_York \
       --env LANG=en_US.UTF-8 \
       --env HOMESEER_CREDENTIALS="default:default" \
       --env DOCKER_HOMESEER_HOST_ROOT="/usr/local/homeseer" \
       ghcr.io/homeseer/homeseer:latest $@

# PUBLISHED IP PORTS
# -------------------------
# 80    : HTTP/WEB
# 1883  : MQTT Broker (Zigbee Plus)
# 10200 : HS-TOUCH
# 10300 : myHS
# 10401 : SPEAKER CLIENTS
# 11000 : ASCII/JSON REMOTE API

# OTHER COMMON OPTIONS
# -------------------------
# --detach
# --restart always
# --device /dev/ttyUSB0
# --device /dev/ttyUSB1
# --device /dev/ttyACM0
# --volume /etc/localtime:/etc/localtime:ro
