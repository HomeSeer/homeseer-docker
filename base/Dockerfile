#########################################
# HOMESEER (V4) LINUX - DOCKERFILE
#########################################
FROM debian:trixie-slim

# build arguments
ARG TARGETARCH
ARG TARGETVARIANT
ARG BUILDDATE
ARG VERSION
ARG DEBIAN_FRONTEND=noninteractive

# custom STOP signal for 'docker stop'
STOPSIGNAL SIGQUIT

# environment variables
ENV LANG=en_US.UTF-8
ENV TZ="America/New_York"
ENV HOMESEER_FOLDER="/homeseer"

# docker container image labels
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILDDATE
LABEL org.label-schema.name="ghcr.io/spudwebb/homeseer-base"
LABEL org.label-schema.description="HomeSeer Base Docker Image"
LABEL org.label-schema.url="https://homeseer.com/"
LABEL org.label-schema.vcs-url="https://github.com/spudwebb/homeseer-docker"
LABEL org.label-schema.vendor="HomeSeer Technologies"
LABEL org.label-schema.version=$VERSION

RUN echo "================================================================" && \
    echo "  BUILDING DOCKER HOMESEER BASE ($VERSION) IMAGE FOR: $TARGETARCH $TARGETVARIANT" && \
    echo "================================================================"

# Replace sudo with a passthrough wrapper
RUN echo '#!/bin/sh\nexec "$@"' > /usr/bin/sudo && \
    chmod +x /usr/bin/sudo

# set non-interactive frontend
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# update locale/language
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y locales && \
	rm -rf /var/lib/apt/lists/*
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

# install container tools
RUN apt-get update && \
    apt-get install --yes tmux curl wget nano apt-utils net-tools iputils-ping etherwake ssh-client mosquitto-clients dos2unix dirmngr ca-certificates gnupg binutils docker-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


# trixie no longer allows mono-project's obsolete signature verification, 25keypolicy file is used to bypass the check
# https://neilzone.co.uk/2026/01/dealing-with-apts-warning-policy-will-reject-signature-within-a-year-see-audit-for-details/
RUN mkdir -p /etc/apt/apt.conf.d
COPY --chmod=644 etc/apt/apt.conf.d/25keypolicy /etc/apt/apt.conf.d/

# install mono
RUN rm -f /usr/share/keyrings/mono-official-archive-keyring.gpg && \
    gpg --homedir /tmp --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/mono-official-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    chmod +r /usr/share/keyrings/mono-official-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/debian stable-buster main" > /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    apt-get install --yes mono-complete mono-devel mono-vbnc mono-xsp4 referenceassemblies-pcl ca-certificates-mono && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

# install HomeSeer dependencies
# alsa-base (not available in Debian upstream)
RUN apt-get update && \
    apt-get install --yes aha ffmpeg alsa-utils flite \
                          avahi-discover libavahi-compat-libdnssd-dev libnss-mdns  \
                          avahi-daemon avahi-utils mdns-scan && \
    apt-get remove --yes brltty && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# copy container homeseer override scripts
COPY homeseer/*.sh    /scripts/

# copy container runtime scripts
COPY usr/local/sbin/* /scripts/

# ensure scripts are executable
RUN chmod a+x /scripts/*

# ensure scripts are line-encoded for unix/linux
RUN dos2unix /scripts/*

# remove "reboot" and "shutdown" binaries from the container
# (we will replace with symlinks to scripts)
RUN rm -f /sbin/reboot && rm -f /sbin/shutdown

# create symlinks in bin path ("/usr/local/sbin")
RUN ln -sf /scripts/homeseer /usr/local/sbin/homeseer && \
    ln -sf /scripts/reboot   /usr/local/sbin/reboot   && \
    ln -sf /scripts/shutdown /usr/local/sbin/shutdown && \
    ln -sf /scripts/poweroff /usr/local/sbin/poweroff

# copy default configuration files
COPY etc/avahi/avahi-daemon.conf /etc/avahi/avahi-daemon.conf

# make folders for DBUS & AVAHI
# apply folder permissions for DBUS & AVAHI
RUN mkdir -p /var/run/dbus && \
    mkdir -p /var/run/avahi-daemon && \
    chown messagebus:messagebus /var/run/dbus && \
    chown avahi:avahi /var/run/avahi-daemon

# define IP ports to be exposed by this container
# 80    : HTTP/WEB
# 10200 : HS-TOUCH
# 10300 : myHS
# 10401 : SPEAKER CLIENTS
# 11000 : ASCII/JSON REMOTE API
EXPOSE 80 10200 10300 10401 11000

# define required volume
VOLUME ["/homeseer"]

# set the working path
WORKDIR "/homeseer"

# launch homeseer script in container on startup
CMD ["/usr/local/sbin/homeseer"]