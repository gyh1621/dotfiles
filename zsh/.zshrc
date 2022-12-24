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
PURE_PROMPT_SYMBOL="%F{white}%T%f ❯"
PURE_PROMPT_VICMD_SYMBOL="%F{white}%T%f ❮"
#PURE_PROMPT_SYMBOL="👍 "
#PROMPT='%(?.%F{magenta}👍 .%F{red}✋ )%f
#PROMPT='%F{white}%* '$PROMPT  # add time
PROMPT='%(1j.[%j] .)% '$PROMPT # add job number

# change the path color
zstyle :prompt:pure:path color yellow

# change the color for both `prompt:success` and `prompt:error`
zstyle ':prompt:pure:prompt:*' color cyan
zstyle ':prompt:pure:git:branch' color cyan

# turn on git stash status
zstyle :prompt:pure:git:stash show yes

############# ALIAS ##################
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
alias ll="ls -alG"
alias bat="bat --theme=gruvbox-dark --color=always"

# git alias
alias g="git"
alias gst="git status"
alias gl="git pull"
alias glr="git pull -r"
alias gp="git push"
alias gcd="git commit --amend --no-edit"


############## PLUGINS ################

# enable current word completion
zstyle ':completion:*' matcher-list 'b:=*'

autoload -U compinit && compinit;

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with ls when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'ls -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# kill
zstyle ':fzf-tab:complete:(\\|*/|)(kill|ps):argument-rest' fzf-preview \
  '[ "$group" = "process ID" ] && ps -p$word -wocmd --no-headers \
  | bat --color=always -plsh'
zstyle ':fzf-tab:complete:(\\|*/|)(kill|ps):argument-rest' fzf-flags \
  --preview-window=down:3:wrap

# envs
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	fzf-preview 'echo ${(P)word}'

# files
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --theme=gruvbox-dark --color=always ${(Q)realpath}'

source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
enable-fzf-tab

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# rebind fzf comp keys
bindkey -M vicmd '^O' fzf-history-widget
bindkey -M viins '^O' fzf-history-widget

# zsh-vi-mode
source ~/.zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# zsh-defer
source ~/.zsh/plugins/zsh-defer/zsh-defer.plugin.zsh

# zsh-z
zsh-defer source ~/.zsh/plugins/zsh-z/zsh-z.plugin.zsh

# zsh-autosuggestions
zsh-defer source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

# zsh-syntax-highlighting
zsh-defer source  ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fancy-ctrl-z
zsh-defer source ~/.zsh/plugins/fancy-ctrl-z.plugin.zsh

# git fuzzy
export PATH=~/.zsh/plugins/git-fuzzy/bin:$PATH


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
export PATH=/usr/local/bin:$PATH
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
fv() {
  fzf --preview 'bat {-1} --color=always'
}

# git log show with fzf
gli() {

  # param validation
  if [[ ! `git log -n 1 $@ | head -n 1` ]] ;then
    return
  fi

  # filter by file string
  local filter
  # param existed, git log for file if existed
  if [ -n $@ ] && [ -f $@ ]; then
    filter="-- $@"
  fi

  # git command
  local gitlog=(
    git log
    --graph --color=always
    --abbrev=7
    --format='%C(auto)%h %an %C(blue)%s %C(yellow)%cr'
    $@
  )

  # fzf command
  local fzf=(
    fzf
    --ansi --no-sort --reverse --tiebreak=index
    --preview "f() { set -- \$(echo -- \$@ | grep -o '[a-f0-9]\{7\}'); [ \$# -eq 0 ] || git show --color=always \$1 $filter; }; f {}"
    --bind "ctrl-q:abort,ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % $filter | less -R') << 'FZF-EOF'
                {}
                FZF-EOF"
   --preview-window=right:60%
  )

  # piping them
  $gitlog | $fzf
}


############# MISC ################
# edit command in the editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd ' ' edit-command-line

bindkey -M vicmd "^[[A" history-beginning-search-backward
bindkey -M viins "^[[A" history-beginning-search-backward
bindkey -M vicmd "^[[B" history-beginning-search-forward
bindkey -M viins "^[[B" history-beginning-search-forward

if [ -x "$(command -v rbenv)" ]; then
    eval "$(rbenv init -)"
    export PATH="$HOME/.rbenv/bin:$PATH"
fi

# wezterm
if [ -x "$(command -v wezterm)" ]; then
    alias nw="wezterm cli spawn --new-window"
fi
# First and only argument is the desired term title
function rt {
  echo "\x1b]1337;SetUserVar=panetitle=$(echo -n $1 | base64)\x07"
}

[ -f ~/.zshrc.aws ] && source ~/.zshrc.aws && echo "AWS ZSH Configuration: Activated"

[ -f ~/.zshrc.extra ] && source ~/.zshrc.extra && echo "Extra ZSH Configuration: Activated"

#zprof
