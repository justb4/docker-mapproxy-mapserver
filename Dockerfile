FROM justb4/mapproxy:latest
# Extend MapProxy image with MapServer binaries. Only for local tilegen, no MapServer services.
#
LABEL maintainer="Just van den Broecke <just@justobjects.nl>"

ARG TZ="Europe/Amsterdam"
ARG MAPSERVER_VERSION="7.2.*"

ENV DEBIAN_FRONTEND="noninteractive" \
	MS_DEBUGLEVEL="0" \
	MS_ERRORFILE="stderr"
	
USER root

RUN apt-get -y update \
    && apt-get install -y --no-install-recommends mapserver-bin=${MAPSERVER_VERSION} \
    && apt autoremove -y  \
    && rm -rf /var/lib/apt/lists/*

USER mapproxy
