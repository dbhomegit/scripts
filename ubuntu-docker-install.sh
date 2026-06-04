#!/bin/bash
# docker-install.sh
# Installs Docker Engine and the Compose plugin on Ubuntu
# from Docker's official apt repository.
#
# Tested on: Ubuntu 26.04 (Resolute)
# Usage: sudo ./ubuntu-docker-install.sh

set -euo pipefail

echo "==> Removing conflicting old packages..."
for pkg in docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc; do
    sudo apt-get remove -y "$pkg" 2>/dev/null || true
done

echo "==> Installing prerequisites..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl

echo "==> Adding Docker's official GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "==> Adding Docker apt repository..."
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

echo "==> Installing Docker Engine and Compose plugin..."
sudo apt-get update
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

echo "==> Verifying installation..."
sudo docker run hello-world
docker compose version

echo "==> Done!"
