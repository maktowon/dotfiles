# paths
export PATH=$PATH:/home/maktowon/.local/bin

# shell integrations
eval "$(fzf --zsh)"
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/config.toml)"
eval "$(dircolors -b)"
# eval "$(/opt/homebrew/bin/brew shellenv)"  # uncomment if on mac


# zinit and plugins dir
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"

# download zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# load zinit
source "${ZINIT_HOME}/zinit.zsh"

# add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# load completions
autoload -Uz compinit && compinit

# completion options
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS

# other options
setopt GLOB_DOTS
setopt INTERACTIVE_COMMENTS

# keybindings
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# aliases
alias v='nvim'

# eza (ls replacement)
alias ls='eza --icons=auto --group-directories-first --hyperlink'
alias la='ls -a'
alias ll='ls -l --git --no-user --header --time-style=long-iso'
alias lla='ll -a'
alias lt='ls --tree --git-ignore'
alias lta='lt -a -I .git'
alias lss='ll -s size --total-size'     # sort by size, dirs show full size
alias lsm='ll -s modified -r'           # newest first
alias lgr='ll -a --git-repos'           # show git status of subfolders that are repos
alias lf='ls -D'                        # directories only

# bat (cat replacement), config in ~/.config/bat/config
alias cat='bat --paging=never'          # highlighted cat, no pager
alias catc='bat --plain --paging=never' # no decorations, safe to copy from
alias catp='bat'                        # bat with pager
alias -g -- --help='--help 2>&1 | bat --plain --language=help'  # colored --help everywhere
export MANPAGER="sh -c 'col -bx | bat --language=man --plain'"  # colored man pages
export MANROFFOPT='-c'

# scroll the preview by half a page (vim-style)
export FZF_DEFAULT_OPTS="--bind 'ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up'"

# fzf previews: tree for directories, bat for files (ctrl-t, alt-c, fp)
_fzf_preview='if [ -d {} ]; then eza --tree -a -I .git --color=always --icons=always --group-directories-first {}; else bat --color=always --style=numbers --line-range=:300 {}; fi'
export FZF_CTRL_T_OPTS="--preview '$_fzf_preview' --bind 'ctrl-/:toggle-preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 -a -I .git --color=always --icons=always --group-directories-first {}'"
fp() { fzf --preview "$_fzf_preview" "$@" }  # fuzzy file picker with preview

# yazi (file manager), config in ~/.config/yazi
# y: open yazi; quit with Q to cd the shell to wherever you ended up (q stays put)
y() {
  local tmp="$(mktemp -t yazi-cwd.XXXXXX)" cwd
  YAZI_START="$PWD" command yazi "$@" --cwd-file="$tmp"  # YAZI_START is used by g w in yazi
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}
alias yazi='y'                          # plain yazi also gets Q cd-on-quit and g w
bindkey -s '^o' '^uy\n'                 # ctrl-o: open yazi from the prompt

# lazygit, config in ~/.config/lazygit
# lg: quit with q to cd the shell into the repo you ended up in (Q stays put)
function lg {
  local tmp="$(mktemp -t lazygit-cwd.XXXXXX)" cwd
  LAZYGIT_NEW_DIR_FILE="$tmp" command lazygit "$@"
  [ -s "$tmp" ] && cwd="$(<"$tmp")"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}
bindkey -s '^g' '^ulg\n'                # ctrl-g: open lazygit from the prompt

# editor
export EDITOR='nvim'
export VISUAL='nvim'

