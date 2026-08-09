#!/usr/bin/env bash
#
# should be safe to re-run any time. existing correct symlinks are left alone.
# if something exists at a target path, it gets moved into
# backups/<timestamp>/ rather than overwritten.
set -e


DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$DOTFILES_DIR/backups/$(date +%Y%m%d-%H%M%S)"

link() {
    local src="$DOTFILES_DIR/$1"
    local dest="$2"

    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "OK         $dest"
        return
    fi

    # something else exists there (a real file, or a symlink pointing
    # elsewhere) - back it up before touching it.
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$dest" "$BACKUP_DIR/"
        echo "BACKED UP  $dest -> $BACKUP_DIR/"
    fi

    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    echo "LINKED     $dest -> $src"
}

echo "installing dotfiles from $DOTFILES_DIR"
echo ""

# --- bash ---
link "bashrc" "$HOME/.bashrc"

# --- fish ---
mkdir -p "$HOME/.config/fish/conf.d"

for f in "$DOTFILES_DIR"/fish/conf.d/*.fish; do
    [ -e "$f" ] || continue  # skip if the glob matched nothing
    name="$(basename "$f")"
    link "fish/conf.d/$name" "$HOME/.config/fish/conf.d/$name"
done


mkdir -p "$HOME/.config/git"
link "gitignore_global" "$HOME/.config/git/ignore"

echo ""
if [ -d "$BACKUP_DIR" ]; then
    echo "some existing files were backed up to:"
    echo "  $BACKUP_DIR"
    echo ""
fi
echo "Done."
