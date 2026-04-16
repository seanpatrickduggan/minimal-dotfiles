#!/usr/bin/env bash
# Deploy configs — symlinks dotfiles into place
# Usage: ./deploy.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
    local src="$1" dst="$2"
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        echo "  backing up $dst -> ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -sfn "$src" "$dst"
    echo "  $dst -> $src"
}

echo "Deploying configs..."

# Neovim
link "$SCRIPT_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"

# Tmux (2.7 only reads ~/.tmux.conf, not ~/.config/tmux/)
link "$SCRIPT_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

# Zsh
link "$SCRIPT_DIR/zsh/.zshrc" "$HOME/.zshrc"

echo "Done. Restart your shell or run: source ~/.zshrc"
