#!/usr/bin/bash

# functions
checkValid() 
{
if [ $1 -ge 1 ]; then
  echo "Script recived error"
  exit $1
fi
}

echo "Should run In Ubuntu-server Distro"
sleep 5
# this parameters for update the grub for cgroup v1
PARAMETERS="cgroup_enable=memory swapaccount=1"

read -p "enter the username: " username
read -p "enter the password for user $username : " password

echo "This script working on debian bases ,pls use ubuntu on server!"

useradd -m -s /bin/bash "$username"
echo "$username:$password" | chpasswd
usermod -aG sudo $username

echo "setup for domjudge"
# setup for domjudge
apt update && apt upgrade -y
apt install nginx  vim zsh ca-certificates curl wget update-grub -y


# Add Docker's official GPG key:
sudo apt-get update
sudo apt install ca-certificates curl gnupg lsb-release
# select the ubunto version
read -p "enter the ubuntu version: 1 = 22.4 , 2 = 24.4 " version
if [ $version == '2' ]; then
# for 24 version
echo "Add Docker's official GPG key for 24 version"

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg


# Add the repository to Apt sources:
echo "Add the repository to Apt sources 22"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu jammy stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
elif [ $version == '1' ]; then
# for 22 version

echo "Add Docker's official GPG key for 22 version"
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo "Add the repository to Apt sources"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

else
    echo "you are very idiot plese run again scripts."
    exit 1
fi

sudo apt-get update
echo "FINISH"
# Install Docker Engine, CLI, and Containerd:

echo "Install Docker Engine, CLI, and Containerd"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker run hello-world
echo "FINISH"

groupadd docker
usermod -aG docker $username

sudo systemctl restart docker.service
while [ true ]
do
  sleep 1
  docker run hello-world
  if [ $? -eq 0 ]; then
    break
  fi
done

checkValid $?
docker pull mariadb:latest 
docker pull domjudge/domserver:9.0.0
docker pull domjudge/judgehost:9.0.0

# Deetc/default/grub /etc/default/grub.bak
# Check if the GRUB_CMDLINE_LINUX line exists
if grep -q "^GRUB_CMDLINE_LINUX=" /etc/default/grub 
then
    # Append the parameters to the existing line
    sed -i "s|^GRUB_CMDLINE_LINUX=\"|&$PARAMETERS |" /etc/default/grub
else
    # If the line does not exist, create it
    echo GRUB_CMDLINE_LINUX="$PARAMETERS"
fi


apt install update-grub
update-grub

echo "Pls reboot the server!"
