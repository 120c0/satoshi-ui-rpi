#!/bin/bash

TEMP_DIR=$(mktemp -d) && cd $TEMP_DIR
DOWNLOAD_URL="https://github.com/neovim/neovim/archive/refs/tags/v0.9.0.tar.gz"
TAR_FILENAME="v0.9.0.tar.gz"
DIRECTORY="neovim-0.9.0"

log() {
  clear && echo -e $1 && sleep 5
}

download_neovim_source() {
  log "\033[32m[+] Download neovim from $DOWNLOAD_URL...\033[0m"
  wget $DOWNLOAD_URL && tar -xvhf $TAR_FILENAME && cd $DIRECTORY
}
install_depends() {
  log "\033[32m[+] Install requirements to compile...\033[0m"
  sudo apt install libncursesw6 cmake libtool-bin ninja-build gettext libevent-dev git build-essential -y
}
install_neovim_default_config() {
  log "\033[32m[+] Install default configs...\033[0m"
  git clone --depth 1 https://github.com/wbthomason/packer.nvim\
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim
  
  mkdir -p $HOME/.config/nvim/lua && echo "require 'setting'
  require 'pluggin'" | tee $HOME/.config/nvim/init.lua

  echo "vim.cmd[[
    set number
    set nocompatible
    
    set softtabstop=2
    set tabstop=2
    set shiftwidth=2
    set autoindent
    set cursorline
    set noswapfile
    set termguicolors
  ]]
  -- colorscheme hemisu" | tee $HOME/.config/nvim/lua/setting.lua

  echo "vim.cmd[[packadd packer.nvim]]
  return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'noahfrederick/vim-hemisu'
  end)" | tee $HOME/.config/nvim/lua/pluggin.lua
}

compile_neovim() {
  log "\033[32m[+] Compile neovim and install...\033[0m"
  sudo make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/opt/neovim -j4 install
}

run() {
  download_neovim_source
  install_depends
  install_neovim_default_config
  compile_neovim
}

run