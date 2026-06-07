#!/usr/bin/env bash
# install.sh – Symlink all dotfiles into $HOME
# Usage: bash install.sh [--dry-run]
#
# Flags:
#   --dry-run   Print what would happen without making any changes
#   --force     Overwrite existing files/symlinks without asking

set -euo pipefail

# ── Config ────────────────────────────────────────────────────────────────────
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Files and directories to symlink (relative to DOTFILES_DIR → $HOME/filename)
DOTFILES=(
    .bashrc
    .bash_profile
    .gitconfig
    .gitignore_global
    .tmux.conf
)

# ── Flags ─────────────────────────────────────────────────────────────────────
DRY_RUN=false
FORCE=false

for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=true ;;
        --force)   FORCE=true   ;;
        *)
            echo "Unknown argument: $arg" >&2
            echo "Usage: $0 [--dry-run] [--force]" >&2
            exit 1
            ;;
    esac
done

# ── Helpers ───────────────────────────────────────────────────────────────────
info()    { printf '\e[36m[info]\e[0m  %s\n' "$*"; }
success() { printf '\e[32m[ok]\e[0m    %s\n' "$*"; }
warning() { printf '\e[33m[warn]\e[0m  %s\n' "$*"; }
error()   { printf '\e[31m[error]\e[0m %s\n' "$*" >&2; }

backup_file() {
    local file="$1"
    if $DRY_RUN; then
        info "DRY-RUN: would back up $file → $BACKUP_DIR/"
        return
    fi
    mkdir -p "$BACKUP_DIR"
    cp -a "$file" "$BACKUP_DIR/"
    success "Backed up $file → $BACKUP_DIR/"
}

link_file() {
    local src="$1"
    local dst="$2"

    # Nothing to do if symlink already points to the right place
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        info "Already linked: $dst"
        return
    fi

    # Handle existing file / symlink
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        if $FORCE; then
            backup_file "$dst"
            if ! $DRY_RUN; then rm -rf "$dst"; fi
        else
            warning "Exists: $dst  (use --force to overwrite)"
            return
        fi
    fi

    if $DRY_RUN; then
        info "DRY-RUN: would link $src → $dst"
    else
        ln -s "$src" "$dst"
        success "Linked: $dst → $src"
    fi
}

# ── Main ──────────────────────────────────────────────────────────────────────
echo ""
info "Dotfiles directory : $DOTFILES_DIR"
info "Home directory     : $HOME"
$DRY_RUN && warning "Dry-run mode enabled – no changes will be made."
echo ""

for dotfile in "${DOTFILES[@]}"; do
    src="$DOTFILES_DIR/$dotfile"
    dst="$HOME/$dotfile"

    if [ ! -e "$src" ]; then
        error "Source not found: $src"
        continue
    fi

    link_file "$src" "$dst"
done

echo ""
success "Done!"
if ! $DRY_RUN; then
    info "Restart your shell or run:  source ~/.bashrc"
fi
