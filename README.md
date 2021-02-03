# OpenVPN and QBittorent with WebUI

Early fork of [docker-transmission-openvpn](https://github.com/haugene/docker-transmission-openvpn/) with transmission replaced with qbittorrent.

This container contains OpenVPN and qBittorrent with a configuration
where qBittorrent is running only when OpenVPN has an active tunnel.
It has built in support for many popular VPN providers to make the setup easier.

## Quick Start

These examples shows valid setups using PIA as provider for both
docker run and docker-compose. Note that you should read some documentation
at some point, but this is a good place to start.

### Docker run

```
$ docker run --cap-add=NET_ADMIN -d \
              -v /your/storage/path/:/data \
              -e OPENVPN_PROVIDER=PIA \
              -e OPENVPN_CONFIG=france \
              -e OPENVPN_USERNAME=user \
              -e OPENVPN_PASSWORD=pass \
              -e LOCAL_NETWORK=192.168.0.0/16 \
              --log-driver json-file \
              --log-opt max-size=10m \
              -p 9091:9091 \
              tpine/qbittorrent-openvpn
```

### Docker Compose
```
version: '3.3'
services:
    transmission-openvpn:
        cap_add:
            - NET_ADMIN
        volumes:
            - '/your/storage/path/:/data'
        environment:
            - OPENVPN_PROVIDER=PIA
            - OPENVPN_CONFIG=france
            - OPENVPN_USERNAME=user
            - OPENVPN_PASSWORD=pass
            - LOCAL_NETWORK=192.168.0.0/16
        logging:
            driver: json-file
            options:
                max-size: 10m
        ports:
            - '9091:9091'
        image: tpine/qbittorrent-openvpn
```
