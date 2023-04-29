#!/bin/bash
ALACRITTY_DOWNLOAD_FILE="v0.12.0.tar.gz"
ALACRITTY_DIRECTORY="alacritty-0.12.0"

SSO=$(pwd)
TEMPLATE=$SSO/templates

MESON_DOWNLOAD_FILE="meson-1.1.0.tar.gz"
MESON_DIRECTORY="meson-1.1.0"

LXC_DOWNLOAD_FILE="lxc-5.0.2.tar.gz"
LXC_DIRECTORY="lxc-lxc-5.0.2"

sudo apt install i3-wm i3status ninja-build fonts-firacode x11-xserver-utils bridge-utils xinit cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 -y
sudo apt build-dep lxc -y

# Download Depends
clear; echo "Sleep 10 - Download Depends..."; sleep 10

cd /tmp
wget https://github.com/alacritty/alacritty/archive/refs/tags/$ALACRITTY_DOWNLOAD_FILE
tar -xvhf $ALACRITTY_DOWNLOAD_FILE

wget https://github.com/mesonbuild/meson/releases/download/1.1.0/$MESON_DOWNLOAD_FILE
tar -xvhf $MESON_DOWNLOAD_FILE

wget https://github.com/lxc/lxc/archive/refs/tags/$LXC_DOWNLOAD_FILE
tar -xvhf $LXC_DOWNLOAD_FILE

clear; echo "Sleep 10 - Compilling LXC..."; sleep 10
cd $LXC_DIRECTORY
python3 ../$MESON_DIRECTORY/meson.py setup -Dprefix=/usr build --buildtype=release
python3 ../$MESON_DIRECTORY/meson.py compile -C build -j4
cd build; sudo ninja install

sudo cp -f $TEMPLATE/lxc-net.config /etc/default/lxc-net

sudo systemctl enable lxc.service
sudo systemctl start lxc.service

mkdir -p $HOME/.config/alacritty
mkdir -p $HOME/.config/i3

cp -f $TEMPLATE/alacritty.config $HOME/.config/alacritty/alacritty.yml
cp -f $TEMPLATE/i3.config $HOME/.config/i3/config
sudo cp -f $TEMPLATE/Keyboard.config /usr/share/X11/xorg.conf.d/Keyboard-10.conf
sudo cp -f $TEMPLATE/i3status.config /etc/i3status.conf
sudo cp -f $TEMPLATE/xinitrc.config $HOME/.xinitrc

clear; cd /tmp
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile=default
source $HOME/.cargo/env

cd $ALACRITTY_DIRECTORY
cargo build --release --no-default-features --features=x11

mkdir -p $HOME/.local/bin
cp target/release/alacritty $HOME/.local/bin
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $HOME/.local/bin/alacritty 10