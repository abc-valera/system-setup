#!/usr/bin/bash

# This is an installation script for the newly created Fedora OS.

echo "Starting the installation process...🚀"

# Catch the error and exit
catch() {
    echo "Error occurred 🚩"
    echo "Exiting... ❌"
    exit 1
}
trap catch ERR

# Step 0. Remove unused software
dnf remove firefox -y
dnf remove gnome-maps -y
dnf remove gnome-tour -y
dnf remove simple-scan -y
dnf remove rhythmbox -y
dnf group remove libreoffice -y

# Step 1. General system setup

# Step 1.1 Update the system
dnf update -y
dnf install dnf-plugins-core -y

# Step 1.2 Install Dev Tools for C
dnf group install c-development -y
dnf install cmake

# Step 1.3 Install git
dnf install git -y

# Step 1.4 Add ssh keys for the new system (don't forget to add them to github after)

mkdir -p /home/abc-valera/.ssh

rm -f /home/abc-valera/.ssh/id_ed_github_personal
ssh-keygen -t ed25519 -C "zoocity14@gmail.com" -N "" -f /home/abc-valera/.ssh/id_ed_github_personal -N ""

rm -f /home/abc-valera/.ssh/id_ed_github_work
ssh-keygen -t ed25519 -C "valeriy.tymofieiev@gmail.com" -N "" -f /home/abc-valera/.ssh/id_ed_github_work -N ""

# Step 1.5 Setup the dotfiles
if [ -d /home/abc-valera/dotfiles ]; then
    rm -rf /home/abc-valera/dotfiles
fi
git clone https://github.com/abc-valera/dotfiles.git /home/abc-valera/dotfiles
cd /home/abc-valera/dotfiles && ./install.sh
cd /home/abc-valera/ || {
    echo "Failed to change directory to /home/abc-valera" >&2
    exit 1
}

# Step 1.6 Install the Gnome Tweak
dnf install gnome-tweak-tool -y

# Step 1.7 Enable RPM Fusion repositories
dnf install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" -y
dnf install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" -y

# Step 2. Install applications

# Step 2.1 Install golang
printf "Downloading latest Go version...\n";

LATEST_GO_VERSION="$(curl --silent https://go.dev/VERSION?m=text | head -n 1)";
rm -rf /usr/local/go
curl -OJ -L --progress-bar "https://go.dev/dl/${LATEST_GO_VERSION}.linux-amd64.tar.gz"
tar -C /usr/local -xzf ${LATEST_GO_VERSION}.linux-amd64.tar.gz
printf "You are ready to Go!";

# Install pyhton
dnf install python3-devel
sudo dnf install gcc-gfortran openblas-devel

# Step 2.1 Install applications with dnf
dnf install vim -y
dnf install nodejs -y

# Step 2.2 Build applications
# go install github.com/go-task/task/v3/cmd/task@latest
# go install mvdan.cc/sh/v3/cmd/gosh@latest

# Step 2.3 Install applications with flatpak
flatpak install flathub org.onlyoffice.desktopeditors -y
flatpak install flathub org.videolan.VLC -y
flatpak install flathub org.mozilla.firefox -y
flatpak install flathub org.gimp.GIMP -y
flatpak install flathub org.telegram.desktop -y
flatpak install flathub com.spotify.Client -y

# Step 2.4 Install VSCode
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null
dnf install code -y

# Step 2.5 Install Docker
echo "Installing Docker...🐋"
dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo --overwrite -y
dnf install docker-ce docker-ce-cli containerd.io -y

sudo systemctl enable docker

sudo groupadd docker -f
sudo usermod -aG docker abc-valera
echo "Docker installed!🐋"

# Step 3. Configure the look

# Step 3.1 Install and configure the fonts
wget https://github.com/0xType/0xProto/releases/download/2.300/0xProto_2_300.zip
unzip -j 0xProto_2_300.zip "fonts/*" -d /usr/local/share/fonts/0xProto
rm 0xProto_2_300.zip

# Step 3.2 Install the icon theme
dnf install papirus-icon-theme -y

# Step 3.3 Install the custom cursor
dnf install la-capitaine-cursor-theme -y

# Step 4 Manage ownerships
sudo chown -R abc-valera:abc-valera /home/abc-valera

echo "Installation's complete! 🏁"
