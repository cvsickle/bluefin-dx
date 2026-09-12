#!/usr/bin/env bash
set -euo pipefail
STATE=/etc/.brew-default-packages
[[ -f "$STATE" ]] && exit 0
[[ -x /home/linuxbrew/.linuxbrew/bin/brew ]] || exit 0

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install lazydocker devcontainer
touch "$STATE"
