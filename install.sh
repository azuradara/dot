#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
CONFIG_DIR="$HOME/.config"

backup_if_exists() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$target")"
        mv "$target" "$BACKUP_DIR/$target"
    elif [ -L "$target" ]; then
        rm "$target"
    fi
}

create_symlink() {
    local source="$1"
    local target="$2"
    
    mkdir -p "$(dirname "$target")"
    backup_if_exists "$target"
    ln -sf "$source" "$target"
    echo "$target -> $source"
}

for item in "$DOTFILES_DIR"/.*; do
    item_name=$(basename "$item")
    if [ -f "$item" ] && [ "$item_name" != "." ] && [ "$item_name" != ".." ] && [ "$item_name" != ".git" ]; then
        create_symlink "$item" "$HOME/$item_name"
    fi
done

if [ -d "$DOTFILES_DIR/.config" ]; then
    for item in "$DOTFILES_DIR/.config"/*; do
        if [ -e "$item" ]; then
            item_name=$(basename "$item")
            create_symlink "$item" "$CONFIG_DIR/$item_name"
        fi
    done
fi

