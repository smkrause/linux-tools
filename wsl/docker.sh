#!/bin/bash

# Prompt for sudo password upfront
sudo -v

# Keep the sudo session alive until the script finishes
(while true; do sudo -v; sleep 60; done;) &

# Update and upgrade packages
sudo apt update && sudo apt upgrade -y

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install Homebrew's dependencies if you have sudo access
sudo apt install -y build-essential

# We recommend that you install GCC
brew install gcc

# Add Docker's official GPG key and repository
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker and its dependencies
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add the current user to the Docker group
sudo usermod -aG docker ${USER}

# Restart Docker service to apply changes
sudo systemctl restart docker

# Install NVIDIA Container Toolkit
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Update package lists and install NVIDIA Container Toolkit packages
sudo apt update
sudo apt install -y nvidia-container-toolkit

# Configure Docker to use Nvidia driver and restart Docker
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# Kill the background sudo session keeper
kill %1

echo "-----------------------------------------"
echo "Docker has been installed and configured."
echo "***Please log out*** for the Docker group changes to take effect."
