#!/bin/bash
echo "ip_resolve=4" >> /etc/yum.conf
sudo yum remove docker \
          docker-common \
          container-selinux \
          docker-selinux \
          docker-engine \
          docker-engine-selinux
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --enable extras
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce
<< COMMENTOUT
# なぜか「No such file or directory」となるため、settingDocker.shに分割
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "storage-driver": "devicemapper"
}
EOF
COMMENTOUT

systemctl start docker
systemctl enable docker
