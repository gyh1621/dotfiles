# Setup

Run zsh/setup.sh first
Run powerline/setup.sh first

RUN THIS SCRIPT INSIDE TMUX

There still exists some bugs need to manually fix:

- After running setup.sh, "powerline-daemon" not found will show and tmux need to restart
- If right part of powerline not showing, add "set -g status-right '#(.local/bin/powerline tmux right)'" to .tmux.conf
