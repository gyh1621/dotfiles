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
# PURE_PROMPT_SYMBOL="%F{white}%T%f ❯"
# PURE_PROMPT_VICMD_SYMBOL="%F{white}%T%f ❮"
PURE_PROMPT_SYMBOL="%F{green}󰊠  󰇘 "
PURE_PROMPT_VICMD_SYMBOL="%F{green}󱙝  󰇙"
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

alias vim="nvim"

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
source  ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fancy-ctrl-z
zsh-defer source ~/.zsh/plugins/fancy-ctrl-z.plugin.zsh

# git fuzzy
export PATH=~/.zsh/plugins/git-fuzzy/bin:$PATH

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

# NVM
export NVM_DIR="$HOME/.nvm"
nvm() {
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  nvm $@
}

############# MISC ################
# Initialize Homebrew if it is installed
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval $(/opt/homebrew/bin/brew shellenv)
fi
export PATH="/opt/homebrew/bin:${PATH}"

# Lazy load pyenv
export PYENV_ROOT="${PYENV_ROOT:=${HOME}/.pyenv}"
if ! type pyenv > /dev/null && [ -f "${PYENV_ROOT}/bin/pyenv" ]; then
    export PATH="${PYENV_ROOT}/bin:${PATH}"
fi
if type pyenv > /dev/null; then
    export PATH="${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:${PATH}"
    function pyenv() {
        unset -f pyenv
        eval "$(command pyenv init -)"
        if [[ -n "${ZSH_PYENV_LAZY_VIRTUALENV}" ]]; then
            eval "$(command pyenv virtualenv-init -)"
            eval "$(command pyenv virtualenv-init -)"
        fi
        pyenv $@
    }
fi

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

# SGPT wrapper
#
# Examples
#   sgpt "list files older than 30 days"
#   sgpt --fast "summarise this log"
#   git diff | sgpt --model gpt-4o "explain these changes"
#
# Flags
#   --fast          Prefer a low-latency cheap model (gpt-3.5-turbo)
#   --cheap         Alias for --fast
#   --long          Prefer a large-context model (gpt-4o-mini)
#   --smart         Use smart endpoint + model
#   --model <name>  Explicit model override
#   --shell|-s      Shell command generation mode; takes a prompt argument
#
# ENV VARS
#   SGPT_MODEL      Default model if no flag given
#   OPENAI_API_KEY  Required
#   API_BASE_URL    Optional; defaults to https://llm.0x7cc.com/v1
#
# -------------------------------------------------------------------

sgpt() {
  # --- Local Configuration (EDIT THESE VALUES) -----------------------------
  # IMPORTANT: Replace placeholders with your actual credentials/URL
  local local_api_key="sk-ILVbdTEDQT0N4R8UJPIypQ"
  local local_base_url="https://llm.0x7cc.com/v1"

  if [[ "$local_api_key" == "YOUR_OPENAI_API_KEY_HERE" || -z "$local_api_key" ]]; then
    echo "no openai api key"
    return 1
  fi

  # --- Defaults & models ----------------------------------------------------
  local default_model="${SGPT_MODEL:-gpt-4o}"
  local fast_model="gpt-4o"
  local long_model="gpt-5.1"
  local smart_model="enhanced-chat-o3"

  local model="$default_model"
  local shell_mode=0
  local shell_prompt=""
  local args=()

  # --- Parse args -----------------------------------------------------------
  # Only parse wrapper-specific options. Collect all others for the inner command.
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --fast|--cheap)
        model="$fast_model"
        shift
        ;;
      --smart)
        model="$smart_model"
        local_base_url="https://autogen.0x7cc.com/v1"
        shift
        ;;
      --long)
        model="$long_model"
        shift
        ;;
      --model)
        if [[ $# -lt 2 || "$2" == --* ]]; then
          echo "Error: --model requires an argument." >&2
          return 1
        fi
        model="$2"
        shift 2
        ;;
      --shell|-s)
        # --shell is a wrapper option that takes the *shell prompt* as its argument
        if [[ $# -lt 2 || "$2" == --* ]]; then
          echo "Error: --shell requires a prompt argument." >&2
          return 1
        fi
        shell_mode=1
        shell_prompt="$2"
        shift 2
        ;;
      --)
        shift # Consume the --
        args+=("$@") # Add all remaining arguments to args
        break
        ;;
      *)
        args+=("$1")
        shift
        ;;
    esac
  done

  # --- Common Docker flags (Credentials & Volume) ---------------------------
  local docker_common_flags=(
    --rm
    --volume gpt-cache:/tmp/shell_gpt
    --env "OPENAI_API_KEY=${local_api_key}"
    --env "API_BASE_URL=${local_base_url}"
  )
  local image="ghcr.io/ther1d/shell_gpt"

  # always pass model
  local docker_model_arg=(--model "$model")

  if (( shell_mode )); then
    # --- Shell-mode: capture & execute on host -----------------------------
    if [[ -z "$shell_prompt" ]]; then
      echo "Error: --shell requires a prompt." >&2
      return 1
    fi

    echo "🔧 Generating command..." >&2
    local cmd
    cmd=$(
      docker run "${docker_common_flags[@]}" \
        "$image" \
        "${docker_model_arg[@]}" --shell --no-interaction "$shell_prompt" "${args[@]}"
    )
    local code=$?
    if (( code != 0 )); then
      echo "Error: failed to generate command (exit code $code)" >&2
      return $code
    fi
    if [[ -z "$cmd" ]]; then
      echo "Error: Generated command is empty." >&2
      return 1
    fi

    echo
    echo -e "Shell-GPT → \033[1;33m$cmd\033[0m"
    echo

    # --- Prompt on the real terminal (FIX: avoid immediate EOF) ------------
    local choice=""
    printf '%s' $'\033[1m[E]\033[0m\033[1;32mxecute (default)\033[0m, \033[1m[D]\033[0mescribe, \033[1m[A]\033[0m\033[1;31mbort\033[0m: '

    # Always read from controlling terminal; treat EOF as default (execute)
    if ! IFS= read -r choice </dev/tty; then
      choice=""
    fi

    # Convert to lowercase (zsh)
    local lower_choice="${choice:l}"

    case "$lower_choice" in
      e|execute|"")
        printf "\n"
        echo "⚡ Executing..."
        printf "\n"
        eval "$cmd"
        ;;
      d|describe)
        printf "\n"
        echo "📖 Describing command..."
        printf "\n"
        docker run -it "${docker_common_flags[@]}" \
          "$image" \
          "${docker_model_arg[@]}" "Describe $shell_prompt" "${args[@]}"
        ;;
      a|abort|*)
        printf "\n"
        echo "🚫 Aborted."
        ;;
    esac
    echo
  else
    # --- Normal (non-shell) mode: Correct handling of piping ----------------
    local docker_interactive_flags=()
    if [[ ! -t 0 ]]; then
      docker_interactive_flags=(-i)
    else
      docker_interactive_flags=(-it)
    fi

    docker run "${docker_common_flags[@]}" "${docker_interactive_flags[@]}" \
      "$image" \
      "${docker_model_arg[@]}" "${args[@]}"
  fi
}

gc() {
  local DIFF PROMPT
  local -a untracked

  untracked=("${(@f)$(git ls-files --others --exclude-standard)}")

  DIFF="$(
    git diff
    git diff --cached
    for f in "${untracked[@]}"; do
      git diff --no-index /dev/null "$f" || true
    done
  )"

  [[ -z "$DIFF" ]] && { echo "No changes to commit."; return 1; }

  PROMPT=$'Generate a git commit command (git add <all changed files> && git commit -m "...") using conventional commits.\n'\
$'Only output the command.\n\nDIFF:\n'"$DIFF"

  sgpt --long -s "$PROMPT"
}


# git contributors stats (commits + +/- lines + files touched)
# Usage:
#   gitcontrib                         # all history, whole repo
#   gitcontrib -s "30 days ago"        # last 30 days
#   gitcontrib -s 2025-12-01 -u 2025-12-31
#   gitcontrib -p src                  # only pathspec src
#   gitcontrib --merges                # include merge commits
gitcontrib() {
  emulate -L zsh
  setopt pipefail

  local since="" until="" pathspec="." include_merges=0 use_mailmap=1

  while (( $# )); do
    case "$1" in
      -s|--since) shift; since="$1" ;;
      -u|--until) shift; until="$1" ;;
      -p|--path)  shift; pathspec="$1" ;;
      --merges)   include_merges=1 ;;
      --no-mailmap) use_mailmap=0 ;;
      -h|--help)
        cat <<'EOF'
gitcontrib - local "GitHub contributors-like" stats

Options:
  -s, --since <date>     e.g. "30 days ago" / "2025-01-01"
  -u, --until <date>     e.g. "now" / "2025-12-31"
  -p, --path  <path>     limit by pathspec (default ".")
      --merges           include merge commits (default: exclude)
      --no-mailmap       do not apply .mailmap mappings (default: apply)
  -h, --help

Examples:
  gitcontrib
  gitcontrib -s "30 days ago"
  gitcontrib -p src
  gitcontrib --no-mailmap
EOF
        return 0
        ;;
      *)
        # allow raw pathspec as last arg
        if [[ "$pathspec" == "." ]]; then
          pathspec="$1"
        else
          print -u2 "gitcontrib: unknown arg: $1"
          return 2
        fi
        ;;
    esac
    shift
  done

  local -a log_args
  log_args=(--pretty=format:'__AUTH__%aN <%aE>' --numstat)
  (( use_mailmap )) && log_args=(--use-mailmap "${log_args[@]}")
  (( include_merges )) || log_args=(--no-merges "${log_args[@]}")
  [[ -n "$since" ]] && log_args+=(--since="$since")
  [[ -n "$until" ]] && log_args+=(--until="$until")

  git log "${log_args[@]}" -- "$pathspec" \
  | awk '
      # Author line marker (space-safe)
      index($0, "__AUTH__")==1 {
        author = substr($0, 9)   # strip marker
        commits[author]++
        next
      }

      # numstat: add del path
      NF==3 {
        # binary files show "-" in numstat
        if ($1 ~ /^[0-9]+$/) add[author] += $1
        if ($2 ~ /^[0-9]+$/) del[author] += $2
        files[author]++
        next
      }

      END {
        for (a in commits) {
          c = commits[a]
          p = (a in add) ? add[a] : 0
          m = (a in del) ? del[a] : 0
          f = (a in files) ? files[a] : 0
          printf "%09d\t%09d\t%09d\t%+010d\t%09d\t%s\n", c, p, m, p-m, f, a
        }
      }
    ' \
  | sort -nr \
  | awk -F'\t' '
      BEGIN {
        printf "%-6s  %-10s  %-10s  %-10s  %-10s  %s\n", "commits","additions","deletions","net","files","author"
        printf "%-6s  %-10s  %-10s  %-10s  %-10s  %s\n", "------","----------","----------","----------","----------","------"
      }
      {
        gsub(/^0+/, "", $1); if ($1=="") $1=0
        gsub(/^0+/, "", $2); if ($2=="") $2=0
        gsub(/^0+/, "", $3); if ($3=="") $3=0
        sub(/^\+0+/, "+", $4); sub(/^\-0+/, "-", $4)
        gsub(/^0+/, "", $5); if ($5=="") $5=0
        printf "%-6s  %-10s  %-10s  %-10s  %-10s  %s\n", $1,$2,$3,$4,$5,$6
      }
    '
}

# Create a new worktree + branch, then cd into it.
# Usage: ga <branch>
ga() {
  if [[ -z "$1" ]]; then
    echo "Usage: ga <branch>"
    return 1
  fi

  # Ensure git exists
  if ! command -v git >/dev/null 2>&1; then
    echo "ga: git not found in PATH"
    return 1
  fi

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "ga: not inside a git repository"
    return 1
  fi

  local branch="$1"
  local base wpath

  # zsh-safe way to get basename without calling external binary
  base="${PWD:t}"
  wpath="../${base}--${branch}"

  git worktree add -b "$branch" "$wpath" || return 1

  # Optional: trust directory for mise
  if command -v mise >/dev/null 2>&1; then
    mise trust "$wpath" >/dev/null 2>&1 || true
  fi

  cd "$wpath" || return 1
}

# Remove current worktree directory and delete its branch.
gd() {
  local cwd worktree root branch main reply

  if ! command -v git >/dev/null 2>&1; then
    echo "gd: git not found in PATH"
    return 1
  fi

  cwd="$PWD"
  worktree="${cwd:t}"

  # Split on first `--`
  root="${worktree%%--*}"
  branch="${worktree#*--}"

  # Safety guard
  if [[ "$root" == "$worktree" || -z "$branch" ]]; then
    echo "gd: not in a worktree dir named <root>--<branch> (got: $worktree)"
    return 1
  fi

  echo "About to remove worktree and delete branch:"
  echo "  worktree: $cwd"
  echo "  branch:   $branch"
  printf "Continue? [y/N]: "
  read -r reply

  if [[ ! "$reply" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    return 0
  fi

  main="$(cd "$cwd/../$root" 2>/dev/null && pwd)"
  if [[ -z "$main" || ! -d "$main/.git" ]]; then
    echo "gd: main repo not found at ../$root from $cwd"
    return 1
  fi

  cd "$main" || return 1
  git worktree remove "$worktree" --force || return 1
  git branch -D "$branch" || return 1

  echo "✔ Removed worktree and deleted branch '$branch'"
}

# codex container
codexc() {
    #docker compose run --rm codex codex "$@"
    docker compose run --rm codex codex --dangerously-bypass-approvals-and-sandbox
}

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

# opencode
export PATH=/Users/gyh/.opencode/bin:$PATH
export CRS_OAI_KEY="cr_356a38a4627de5ddc6f5efec8294317bad374855343ccfe5f4e11d76b8a9831b"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
