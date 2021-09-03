export ZSH="$HOME/.oh-my-zsh"

HISTFILE=~/.zsh_history
HISTSIZE=999999999
SAVEHIST=$HISTSIZE

######### lambda theme #########
#ZSH_THEME="lambda-gitster"

########## Pure Theme ###########
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure
ZSH_THEME=""

PURE_CMD_MAX_EXEC_TIME=5
#PROMPT='%(?.%B%F{white}𓅭  .%B%F{red}𓅮  )%f'
PURE_PROMPT_SYMBOL="❯"
PURE_PROMPT_VICMD_SYMBOL="❮"
#PURE_PROMPT_SYMBOL="👍 "
#PROMPT='%(?.%F{magenta}👍 .%F{red}✋ )%f
#PROMPT='%F{white}%* '$PROMPT  # add time
PROMPT='%(1j.[%j] .)% '$PROMPT # add job number

# change the path color
zstyle :prompt:pure:path color cyan

# change the color for both `prompt:success` and `prompt:error`
zstyle ':prompt:pure:prompt:*' color cyan
zstyle ':prompt:pure:git:branch' color yellow

# turn on git stash status
zstyle :prompt:pure:git:stash show yes

########## SPACESHIP THEME SETTINGS ###########
#
#ZSH_THEME="spaceship"
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
SPACESHIP_GIT_STATUS_SHOW=false

spaceship_nonbreak_space() {
    spaceship::section white " "
}

SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  host          # Hostname section
  dir           # Current directory section
  git           # Git section (git_branch + git_status)
#  hg            # Mercurial section (hg_branch  + hg_status)
#  package       # Package version
#  node          # Node.js section
#  docker        # Docker section
#  aws           # Amazon Web Services section
#  venv          # virtualenv section
  pyenv         # Pyenv section
#  golang
  exec_time     # Execution time
  time
  exit_code
  nonbreak_space
  line_sep      # Line break
#  battery       # Battery level and status
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  char          # Prompt character
)

###############################################

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git z fzf-tab zsh-autosuggestions zsh-syntax-highlighting zsh-vi-mode)

source $ZSH/oh-my-zsh.sh

ZVM_VI_SURROUND_BINDKEY="s-prefix"
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_UNDERLINE
# fix zvm overwrite fzf ctrl-r
zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')
# fix zvm with fzf-tab
zvm_after_init_commands+=('source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab/fzf-tab.zsh')
function zvm_before_init() {
  zvm_bindkey viins '^[[A' history-beginning-search-backward
  zvm_bindkey viins '^[[B' history-beginning-search-forward
  zvm_bindkey vicmd '^[[A' history-beginning-search-backward
  zvm_bindkey vicmd '^[[B' history-beginning-search-forward
}

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# pyenv settings
export PATH="$HOME/.pyenv:$PATH"
#eval "$(pyenv init --path)"
#eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"

# LAZY Loading Pyenv
# Try to find pyenv, if it's not on the path
export PYENV_ROOT="${PYENV_ROOT:=${HOME}/.pyenv}"
if ! type pyenv > /dev/null && [ -f "${PYENV_ROOT}/bin/pyenv" ]; then
    export PATH="${PYENV_ROOT}/bin:${PATH}"
fi

# Lazy load pyenv
if type pyenv > /dev/null; then
    export PATH="${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:${PATH}"
    function pyenv() {
        unset -f pyenv
        eval "$(command pyenv init -)"
        if [[ -n "${ZSH_PYENV_LAZY_VIRTUALENV}" ]]; then
            eval "$(command pyenv virtualenv-init -)"
        fi
        pyenv $@
    }
fi

# highlight
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH=~/.local/bin:$PATH

# zle config
bindkey -v  # vi mode

#function zle-line-init zle-keymap-select {
#    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
#    #RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
#    zle reset-prompt
#}

#zle -N zle-line-init
#zle -N zle-keymap-select
#export KEYTIMEOUT=1

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.emacs.d/bin:$PATH"

export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"
export PATH="/usr/local/go/bin:$PATH"

export PATH="/usr/local/opt/openjdk@8/bin:$PATH"

alias vim="/usr/local/Cellar/vim/8.2.3150/bin/vim"

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

# edit command in the editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

# notify <message> [title] [sound]
# for available sound, see: ll /System/Library/Sounds
function notify () {
    readonly MESSAGE=${1:?"message must be set"}
    readonly TITLE=${2:-"iTerm Notification"}
    readonly SOUND=${3:-"Submarine"}
    osascript -e "display notification \"${MESSAGE}\" with title \"${TITLE}\" sound name \"${SOUND}\""
}

# git diff with fzf
fdiff() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd . ~ --type file -L -H'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DIR_COMMAND="fd . ~ --type d -L"
export FZF_ALT_C_COMMAND="$FZF_DIR_COMMAND"

enable-fzf-tab

[ -f ~/.zshrc.aws ] && source ~/.zshrc.aws; echo "AWS ZSH Configuration: Activated"
