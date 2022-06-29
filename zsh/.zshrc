#zmodload zsh/zprof

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
PURE_PROMPT_SYMBOL="%F{yellow}%T%f ❯"
PURE_PROMPT_VICMD_SYMBOL="%F{yellow}%T%f ❮"
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

############# ALIAS ##################
alias ll="ls -al"

# git alias
alias g="git"
alias gst="git status"
alias gl="git pull"
alias glr="git pull -r"
alias gp="git push"
alias gcd="git commit --amend --no-edit"


############## PLUGINS ################

# zsh-vi-mode
source ~/.zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# zsh-defer
source ~/.zsh/plugins/zsh-defer/zsh-defer.plugin.zsh

# FZF
[ -f ~/.fzf.zsh ] && zsh-defer source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd . ~ --type file -L -H'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DIR_COMMAND="fd . ~ --type d -L"
export FZF_ALT_C_COMMAND="$FZF_DIR_COMMAND"

# fzf tab
zsh-defer source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

# zsh-z
zsh-defer source ~/.zsh/plugins/zsh-z/zsh-z.plugin.zsh

# zsh-autosuggestions
zsh-defer source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

# zsh-syntax-highlighting
zsh-defer source  ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fancy-ctrl-z
zsh-defer source ~/.zsh/plugins/fancy-ctrl-z.plugin.zsh


############ PYENV ##############
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


########### FUCK ############
# lazy load fuck
function fk() {
    if ! type fuckme > /dev/null; then
        eval "$(thefuck --alias fuckme)"
    fi
    fuckme $@
}


########### PATH ################
export PATH=~/.local/bin:$PATH

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.emacs.d/bin:$PATH"

export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"
export PATH="/usr/local/go/bin:$PATH"

export PATH="/usr/local/opt/openjdk@8/bin:$PATH"

export PATH="$HOME/.cargo/bin:$PATH"

export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include"


############# CUSTOM FUNCTIONS ############
timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

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


############# MISC ################
# edit command in the editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line


if [ -x "$(command -v rbenv)" ]; then
    eval "$(rbenv init -)"
    export PATH="$HOME/.rbenv/bin:$PATH"
fi

if [ -x "$(command -v wezterm)" ]; then
    alias nw="wezterm cli spawn --new-window"
fi

[ -f ~/.zshrc.aws ] && source ~/.zshrc.aws && echo "AWS ZSH Configuration: Activated"

#zprof
