# dotfiles

Lightweight zsh setup: Oh My Zsh + Powerlevel10k (Lean, two lines, no icons needed),
autosuggestions, syntax highlighting, shared history, and case-insensitive menu completion.
Starts in about 60 ms.

## Install on a new machine

```sh
git clone https://github.com/OmarGuajardo/dotfiles ~/dotfiles
~/dotfiles/install.sh
exec zsh
```

The script installs zsh, git and curl if missing (apt/dnf/pacman/brew), installs Oh My Zsh,
the theme and the plugins, and symlinks the configs into `$HOME`. Any existing `~/.zshrc` or
`~/.p10k.zsh` is backed up first. It's safe to re-run; re-running also updates the theme and plugins.

## Files

| Repo file      | Linked to     | What it holds                          |
|----------------|---------------|----------------------------------------|
| `zsh/zshrc`    | `~/.zshrc`    | plugins, history, completion, aliases  |
| `zsh/p10k.zsh` | `~/.p10k.zsh` | prompt layout and colors               |

Because they're symlinks, editing `~/.zshrc` edits the repo. Commit and push, then
`git pull` on other machines.

Machine-specific settings you don't want to share can go in `~/.zshrc.local`, which is loaded
if it exists and is not part of the repo.
