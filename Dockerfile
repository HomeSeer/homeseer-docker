#########################################
# HOMESEER (V4) LINUX - DOCKERFILE
#########################################
FROM ghcr.io/spudwebb/homeseer-base:latest
ARG TARGETARCH
ARG BUILDDATE
ARG VERSION
ARG DOWNLOAD
ARG DEBIAN_FRONTEND=noninteractive

# docker container image labels
LABEL org.opencontainers.image.description="HomeSeer Docker Image"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.source="https://github.com/spudwebb/homeseer-docker"


RUN echo "========================================================="
RUN echo "  BUILDING DOCKER HOMESEER ($VERSION) IMAGE FOR: $TARGETARCH"
RUN echo "========================================================="

# configure build time environment variables
ENV HOMESEER_VERSION="$VERSION"

# download appropriate version of HomeSeer Linux
RUN wget -O /homeseer.tar.gz "$DOWNLOAD"
