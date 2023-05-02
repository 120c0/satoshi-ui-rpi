#!/bin/sh
echo 'deb http://deb.debian.org/debian bullseye main contrib non-free
deb http://security.debian.org/debian-security bullseye-security main contrib non-free
deb http://deb.debian.org/debian bullseye-updates main contrib non-free
# Uncomment deb-src lines below then "apt-get update" to enable "apt-get source"
deb-src http://deb.debian.org/debian bullseye main contrib non-free
deb-src http://security.debian.org/debian-security bullseye-security main contrib non-free
deb-src http://deb.debian.org/debian bullseye-updates main contrib non-free' | sudo tee /etc/apt/sources.list

sudo apt update -y && sudo apt upgrade -y; clear

echo -e "\n\n\n\n\nNow, use this command: sudo -Hu <USERNAME> env bash ./stage-2"
echo -e "\n\n\n\n\nExemple: sudo -Hu jhondoe env bash stage-2.sh"
echo "Your PC will be reboot in 10s to finish upgrade..."

sleep 10; sudo reboot

