#!/bin/bash
/etc/qbittorrent/start.sh "$@"
[[ ! -f /opt/tinyproxy/start.sh ]] || /opt/tinyproxy/start.sh
