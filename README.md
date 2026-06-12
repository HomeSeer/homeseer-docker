# Docker Container for HomeSeer 4 (Linux)


## Overview

This project provides Docker container images for HomeSeer 4 on Linux.     

The docker images are published via GitHub Container Registry: [![Container](https://img.shields.io/badge/Container-ghcr.io-blue?logo=docker)](https://github.com/HomeSeer/homeseer-docker/pkgs/container/homeseer)
- the `latest` tag tracks the docker image for the latest HS4 release version
- the `beta` tag tracks the docker image for the latest HS4 beta version

---

## TL;DR

Use Docker Compose to start the latest version of HS4 in a docker container 
```
sudo docker compose up -d
```

---

## Supported Architectures

- Intel/AMD 64-bit ( `amd64` / `x86_64` )
- ARM 64-bit ( `arm64` )

---

## Getting Started 

The following docker command will download and launch the latest HomeSeer 4 Docker image.
```shell
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
       ghcr.io/homeseer/homeseer:latest
```

On the first run of the `homeseer` container, the script will take a few minutes while it 
installs the HomeSeer application files to the `/homeseer` mapped volume path.  Subsequent 
container restarts will occur much faster as the HomeSeer application files are already 
installed.  If the container is removed and a new container is launched, the HomeSeer
application file will be re-installed even if they already exist in the `/homeseer` 
mapped volume path.  Note: The installation process should not affect any user configuration, 
plugins or log files.  However, it is always a good idea to make sure you have a complete backup 
of the `/homeseer` mapped volume path prior to any upgrades.   

---

## Docker Compose

Alternatively you can use a `docker-compose.yml` file to launch your homeseer container.
Below is a sample `docker-compose.yml` file you can use to get started:

```yaml
services:
  homeseer:
    container_name: homeseer
    image: ghcr.io/homeseer/homeseer:latest
    hostname: homeseer
    restart: unless-stopped
    stop_grace_period: 1m
    network_mode: bridge
    volumes:
      - /usr/local/homeseer:/homeseer
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - 80:80
      - 1883:1883
      - 10200:10200
      - 10300:10300
      - 10401:10401
      - 11000:11000
    environment:
      TZ: America/New_York
      LANG: en_US.UTF-8
      HOMESEER_CREDENTIALS: "default:default"
      DOCKER_HOMESEER_HOST_ROOT: "/usr/local/homeseer"
```

### Starting the Container
Run the following command in the same directory as your `docker-compose.yml` 
file to launch the container instance.

```
docker compose up -d
```


### Updating the Container
If the `latest` homeseer image has been updated and you want to update your homeseer container run:
```
docker compose pull
docker compose up -d
```

### Stopping the Container
To gracefully stop the HS4 container use:
```
docker compose stop
```
If *"No Password Required for Local (same subnet) Login"* is **disabled** in the HS4 network settings, you must provide valid credentials in order for HS4 to shutdown gracefully:

```
HOMESEER_CREDENTIALS: "username:password"
``` 

---

## Acknowledgments

Credit must be attributed to the following existing repositories and their respective authors.  Much of 
the logic used in this project was based on these prior works. 
 - https://github.com/wpiman/homeseer-docker
 - https://github.com/HomeSeerLinux/homeseer-docker
 - https://github.com/marthoc/docker-homeseer
 - https://github.com/scyto/docker-homeseer
 - https://github.com/E1iTeDa357/docker-homeseer4
