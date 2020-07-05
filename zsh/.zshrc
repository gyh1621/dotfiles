export ZSH="$HOME/.oh-my-zsh"

export ITERM2_SQUELCH_MARK=1

ZSH_THEME="spaceship"
SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true
SPACESHIP_USER_SHOW=always
SPACESHIP_USER_PREFIX="# "
SPACESHIP_USER_COLOR="blue"
SPACESHIP_HOST_SHOW=always
SPACESHIP_HOST_COLOR="yellow"
SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_PREFIX="["
SPACESHIP_TIME_SUFFIX="] "
SPACESHIP_TIME_COLOR="white"
SPACESHIP_EXIT_CODE_SHOW=true

spaceship_iterm2_mark() {
   spaceship::section white "$(iterm2_prompt_mark) "
}

SPACESHIP_PROMPT_ORDER=(
  iterm2_mark
  user          # Username section
  host          # Hostname section
  dir           # Current directory section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  package       # Package version
  node          # Node.js section
  docker        # Docker section
  aws           # Amazon Web Services section
  venv          # virtualenv section
  pyenv         # Pyenv section
  golang
  exec_time     # Execution time
  time
  exit_code
  line_sep      # Line break
  battery       # Battery level and status
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  char          # Prompt character
)

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# highlight
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH=~/.local/bin:$PATH

# zle config
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey -v  # vi mode
bindkey "^r" history-incremental-search-backward
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
bindkey "^?" backward-delete-char

function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
    #RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1

export PATH="$HOME/.emacs.d/bin:$PATH"

export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"
export PATH="/usr/local/go/bin:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

