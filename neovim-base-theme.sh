#!/bin/bash
mkdir -p $HOME/.config/nvim
cd $HOME/.config/nvim

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
	~/.local/share/nvim/site/pack/packer/start/packer.nvim

mkdir -p lua
echo "vim.cmd[[packadd packer.nvim]]

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'noahfrederick/vim-hemisu'
end)" | tee lua/pluggin.lua

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
]]" | tee lua/setting.lua

echo "require 'setting'
require 'pluggin'" | tee init.lua
