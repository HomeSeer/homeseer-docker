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
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILDDATE
LABEL org.label-schema.name="ghcr.io/spudwebb/homeseer"
LABEL org.label-schema.description="HomeSeer Docker Image"
LABEL org.label-schema.url="https://homeseer.com/"
LABEL org.label-schema.vcs-url="https://github.com/spudwebb/homeseer-docker"
LABEL org.label-schema.vendor="HomeSeer Technologies"
LABEL org.label-schema.version=$VERSION

RUN echo "========================================================="
RUN echo "  BUILDING DOCKER HOMESEER ($VERSION) IMAGE FOR: $TARGETARCH"
RUN echo "========================================================="

# configure build time environment variables
ENV HOMESEER_VERSION="$VERSION"

# download appropriate version of HomeSeer Linux
RUN wget -O /homeseer.tar.gz "$DOWNLOAD"
