# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Cookbook

### Fonts

Install font here: [https://www.nerdfonts.com/font-downloads](https://www.nerdfonts.com/font-downloads)

### Mac OS

```bash
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install git neovim lazygit ripgrep fd luarocks ast-grep wget fzf gpg

## Find a way to install lua 5.1 (https://lua.org/start.html#installing)

# LazyVim
git clone git@github.com:OlivierPelletier/nvim.git ~/.config/nvim

# Rust
brew install rustup
rustup-init
rustup component add rust-analyzer

# NodeJS
brew install nvm
nvm install lts/jod
corepack enable
npm install -g neovim prettier 

# Python
brew install pyenv pipx
pyenv install 3.12
pyenv global 3.12
pip install pynvim
pipx install poetry

# Java
curl -s "https://get.sdkman.io" | bash
sdk install java

# Go
brew install go

```
