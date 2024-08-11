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

# Step 0. Check if the OS is Fedora

# Step 1. General system setup

# Step 1.1 Update the system
sudo dnf update -y
sudo dnf install dnf-plugins-core -y

# Step 1.2 Install GCC
sudo dnf install gcc -y

# Step 1.3 Install git
sudo dnf install git -y

# Step 1.4 Download github CLI and add ssh keys for the new system
sudo dnf install gh -y

echo "Login to the abc-valera GitHub account"
gh auth login -w -h GitHub.com -p https -s admin:public_key

ssh-keygen -t ed25519 -C "zoocity14@gmail.com" -N "" -f .ssh/id_ed_github_personal
gh ssh-key add ~/.ssh/id_ed_github_personal.pub --title "Personal Laptop" --type authentication

ssh-keygen -t ed25519 -C "valeriy.tymofieiev@gmail.com" -N "" -f .ssh/id_ed_github_work

# Step 1.5 Setup the dotfiles
git clone git@github.com:abc-valera/dotfiles.git
cd dotfiles && sudo ./install.sh
cd

# Step 1.6 Install the Gnome Tweak
sudo dnf install gnome-tweak-tool -y

# Step 2. Install applications

# Step 2.1 Install applications with dnf
sudo dnf install vim -y
sudo dnf install golang -y
sudo dnf install nodejs -y
sudo dnf install helm -y

sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
sudo dnf install terraform -y

# Step 2.2 Build applications
go install github.com/go-task/task/v3/cmd/task@latest

# Step 2.3 Install applications with flatpak
flatpak install flathub org.onlyoffice.desktopeditors -y
flatpak install flathub org.videolan.VLC -y
flatpak install flathub org.mozilla.firefox -y
flatpak install flathub org.gimp.GIMP -y
flatpak install flathub org.telegram.desktop -y
flatpak install flathub com.spotify.Client -y

# Step 2.4 Install VSCode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null

sudo dnf install code -y

# Step 2.5 Install Docker
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo -y
sudo dnf install docker-ce docker-ce-cli containerd.io -y
sudo systemctl enable docker
sudo groupadd docker && sudo gpasswd -a ${USER} docker && sudo systemctl restart docker
newgrp docker

# Step 3. Configure the look

# Step 3.1 Install and configure the fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/Meslo.zip
unzip Meslo.zip
rm Meslo.zip
sudo mv Meslo /usr/local/share/fonts/

# Step 3.2 Install the icon theme
sudo dnf install papirus-icon-theme -y

# Step 3.3 Install the custom cursor
sudo dnf copr enable tcg/themes -y
sudo dnf install la-capitaine-cursor-theme -y

echo "Installation's complete! 🏁"
