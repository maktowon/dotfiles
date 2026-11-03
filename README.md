# dotfiles

Linux setup: Hyprland with a Quickshell bar, WezTerm, zsh with oh-my-posh, Neovim. Everything is themed Nord.

## Install

Each top-level folder is a [GNU Stow](https://www.gnu.org/software/stow/) package that mirrors `$HOME`:

```sh
git clone git@github.com:maktowon/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow hyprland quickshell wezterm zsh omp nvim git   # or any subset
```

`getty` is the exception. It's a system file, not a home one, so it has its own installer (see below).

## Packages

| Package | What it is |
|---|---|
| `hyprland` | Hyprland compositor, Lua config split into `modules/` (input, keybinds, monitors, look, …) |
| `quickshell` | Bar, launcher and lock screen |
| `wezterm` | Main terminal: sessions, splits, centered status bar, session menu (`sessions.sh`) |
| `kitty`, `ghostty` | Alternative terminals with the same splits and keys, where they support them |
| `zsh` | `.zshrc` (zinit plugins, fzf) and `.zprofile` (starts Hyprland on tty1) |
| `omp` | oh-my-posh prompt |
| `nvim` | Neovim |
| `git` | Git config: SSH for pushes, `gh:` / `me:` URL shortcuts |
| `lazygit`, `yazi`, `bat` | Configs for those tools |
| `getty` | tty1 autologin |

