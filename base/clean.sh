#!/bin/bash -e
############################################
# HOMESEER (V4) LINUX - DOCKER BUILD SCRIPT
############################################

echo
echo "**********************************************************************"
echo "* CLEANING HOMESEER DOCKER IMAGES                                    *"
echo "**********************************************************************"
echo

# remove the builder instance
docker buildx rm homeseer-builder || true

# remove any containers from local Docker registry
docker images -a | grep "ghcr.io/homeseer/homeseer-base" | awk '{print $3}' | xargs docker rmi -f