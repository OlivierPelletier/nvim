# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Cookbook

### Ubuntu

```bash
# Basic tools
sudo add-apt-repository ppa:git-core/ppa
sudo apt update
sudo apt install git tar curl wget unzip htop snapd ripgrep fd-find gzip python3-venv luarocks

# NeoVim version 10+
sudo snap install --beta nvim --classic

# LazyVim
git clone https://github.com/OlivierPelletier/nvim.git ~/.config/nvim

# LazyGit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Java
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java

# Python
python3 -m pip install --break-system-packages --user --upgrade pynvim

# Node.JS
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.bashrc
nvm install lts/jod
npm install -g neovim

# Tree-sitter
cargo install --locked tree-sitter-cli


```

### Mac OS

### Windows
