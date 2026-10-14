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
alias lg='ll -a --git-repos'            # show git status of subfolders that are repos
alias lf='ls -D'                        # directories only

# editor
EDITOR='nvim'

