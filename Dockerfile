# Build Flood UI seperately to keep image size small
FROM alpine:3.13

VOLUME /data
VOLUME /config

RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
	&& echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
	&& apk --no-cache add bash dumb-init ip6tables ufw@community openvpn shadow \
	curl jq tzdata openrc tinyproxy tinyproxy-openrc openssh unrar git \
	&& apk add --no-cache -X "http://dl-cdn.alpinelinux.org/alpine/edge/testing" qbittorrent-nox \
	&& mkdir -p /opt/transmission-ui \
	&& rm -rf /tmp/* /var/tmp/* \
	&& groupmod -g 1000 users \
	&& useradd -u 911 -U -d /config -s /bin/false abc \
	&& usermod -G users abc

# Add configuration and scripts
ADD openvpn/ /etc/openvpn/
ADD qbittorrent/ /etc/qbittorrent/
ADD tinyproxy /opt/tinyproxy/
ADD scripts /etc/scripts/

ENV OPENVPN_USERNAME=**None** \
    OPENVPN_PASSWORD=**None** \
    OPENVPN_PROVIDER=**None** \
    GLOBAL_APPLY_PERMISSIONS=true \
    CREATE_TUN_DEVICE=true \
    ENABLE_UFW=false \
    UFW_ALLOW_GW_NET=false \
    UFW_EXTRA_PORTS= \
    UFW_DISABLE_IPTABLES_REJECT=false \
    PUID= \
    PGID= \
    DROP_DEFAULT_ROUTE= \
    WEBPROXY_ENABLED=false \
    WEBPROXY_PORT=8888 \
    WEBPROXY_USERNAME= \
    WEBPROXY_PASSWORD= \
    LOG_TO_STDOUT=false \
    HEALTH_CHECK_HOST=google.com

HEALTHCHECK --interval=1m CMD /etc/scripts/healthcheck.sh

# Add labels to identify this image and version
ARG REVISION
# Set env from build argument or default to empty string
ENV REVISION=${REVISION:-""}
LABEL org.opencontainers.image.source=https://github.com/tpine/docker-qbittorrent-openvpn
LABEL org.opencontainers.image.revision=$REVISION

# Compatability with https://hub.docker.com/r/willfarrell/autoheal/
LABEL autoheal=true

# Expose port and run
EXPOSE 9091
CMD ["dumb-init", "/etc/openvpn/start.sh"]
