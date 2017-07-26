#!/bin/bash
set -eu

readonly INSTALL_DEFAULT_VERSION=v0.5.0
readonly INSTALL_VERSION=${CONVOY_VERSION:-"${INSTALL_DEFAULT_VERSION}"}

# 前処理
## 一時作業領域作成
tmp_dir=$(mktemp -d)
yum install -y wget

## Convoyのインストール
cd $tmp_dir
wget https://github.com/rancher/convoy/releases/download/"${INSTALL_VERSION}"/convoy.tar.gz
tar xvzf convoy.tar.gz
cp convoy/convoy convoy/convoy-pdata_tools /usr/local/bin/
mkdir -p /etc/docker/plugins/
bash -c 'echo "unix:///var/run/convoy/convoy.sock" > /etc/docker/plugins/convoy.spec'

# systemdへの登録
tee /etc/systemd/system/convoyd.service <<-'EOF'
[Unit]
Description=Docker backup service Convoy daemon
After=docker.service

[Service]
ExecStart=/usr/local/bin/convoy daemon --drivers devicemapper --driver-opts dm.datadev=/dev/vg-docker/lv-data --driver-opts dm.metadatadev=/dev/vg-docker/lv-metadata
KillMode=process

[Install]
WantedBy=multi-user.target
EOF
chmod 664 /etc/systemd/system/convoyd.service

systemctl start convoyd
systemctl enable convoyd

# 後処理
## 一時作業領域削除
trap "
  rm -rf $tmp_dir
" 0
