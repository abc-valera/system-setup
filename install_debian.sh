#!/bin/bash

# This is an installation script for the newly created Debian OS.

echo "Starting the installation process...🚀"

# Catch the error and exit
catch() {
    echo "Error occurred 🚩"
    echo "Exiting... ❌"
    exit 1
}
trap catch ERR

# Step 1. General system setup

# Step 1.1 Update the system
apt-get update -y
apt-get upgrade -y

# Step 1.2 Install Dev Tools for C
apt-get install build-essential -y

# Step 1.3 Install git
apt-get install git -y

# Step 1.4 Add ssh keys for the new system (don't forget to add them to github after)

mkdir -p /home/abc-valera/.ssh

rm -f /home/abc-valera/.ssh/id_ed_github_personal
ssh-keygen -t ed25519 -C "zoocity14@gmail.com" -N "" -f /home/abc-valera/.ssh/id_ed_github_personal -N ""

rm -f /home/abc-valera/.ssh/id_ed_github_work
ssh-keygen -t ed25519 -C "valeriy.tymofieiev@gmail.com" -N "" -f /home/abc-valera/.ssh/id_ed_github_work -N ""

# Step 1.5 Setup the dotfiles
if ! [ -d /home/abc-valera/dotfiles ]; then
    git clone https://github.com/abc-valera/dotfiles.git /home/abc-valera/dotfiles
fi
cd /home/abc-valera/dotfiles && ./install.sh
cd /home/abc-valera/ || {
    echo "Failed to change directory to /home/abc-valera" >&2
    exit 1
}

# Step 2. Install applications

# Step 2.1 Install applications with apt
apt-get install vim -y
apt-get install golang -y
apt-get install nodejs -y

# Step 2.2 Build applications
# go install github.com/go-task/task/v3/cmd/task@latest
# go install mvdan.cc/sh/v3/cmd/gosh@latest

# Step 3 Manage ownerships
sudo chown -R abc-valera:abc-valera /home/abc-valera

echo "Installation's complete! 🏁"
