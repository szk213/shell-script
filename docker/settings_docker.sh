#!/bin/bash
systemctl stop docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "storage-driver": "devicemapper"
}
EOF
systemctl start docker