#!/usr/bin/env bash
# Sets up zsh + Oh My Zsh + Powerlevel10k + plugins, and links the configs
# in this repo into $HOME. Safe to re-run.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$ZSH_DIR/custom"

say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

# 1. zsh + git + curl
need=()
for cmd in zsh git curl; do command -v "$cmd" >/dev/null || need+=("$cmd"); done
if ((${#need[@]})); then
  say "Installing ${need[*]}"
  if   command -v apt-get >/dev/null; then sudo apt-get update -qq && sudo apt-get install -y "${need[@]}"
  elif command -v dnf     >/dev/null; then sudo dnf install -y "${need[@]}"
  elif command -v pacman  >/dev/null; then sudo pacman -S --needed --noconfirm "${need[@]}"
  elif command -v brew    >/dev/null; then brew install "${need[@]}"
  else echo "Please install: ${need[*]}" >&2; exit 1
  fi
fi

# 2. Oh My Zsh (keep our own .zshrc, don't switch shells mid-script)
if [[ ! -d $ZSH_DIR ]]; then
  say "Installing Oh My Zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 3. Theme + plugins
clone() {  # clone <repo> <dest>, or update it if already there
  if [[ -d $2/.git ]]; then git -C "$2" pull -q --ff-only || true
  else say "Cloning $1"; git clone -q --depth=1 "https://github.com/$1" "$2"
  fi
}
clone romkatv/powerlevel10k                 "$ZSH_CUSTOM/themes/powerlevel10k"
clone zsh-users/zsh-autosuggestions         "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone zsh-users/zsh-syntax-highlighting     "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# 4. Link configs (back up any real file that's in the way)
link() {
  local src="$DOTFILES/$1" dest="$HOME/$2"
  if [[ -e $dest && ! -L $dest ]]; then
    mv "$dest" "$dest.bak-$(date +%Y%m%d-%H%M%S)"
    say "Backed up existing $dest"
  fi
  ln -sfn "$src" "$dest"
  say "Linked $dest -> $src"
}
link zsh/zshrc    .zshrc
link zsh/p10k.zsh .p10k.zsh

# 5. Make zsh the login shell
zsh_path="$(command -v zsh)"
if [[ $(getent passwd "$USER" 2>/dev/null | cut -d: -f7 || echo "$SHELL") != "$zsh_path" ]]; then
  say "Setting zsh as your default shell (may ask for your password)"
  chsh -s "$zsh_path" || echo "chsh failed; run: chsh -s $zsh_path"
fi

say "Done. Run 'exec zsh' or open a new terminal."
