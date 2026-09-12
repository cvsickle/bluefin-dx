#!/usr/bin/env bash

set -euo pipefail

BREW_HOME=/usr/share/homebrew/home/linuxbrew
BREW_BIN=${BREW_HOME}/.linuxbrew/bin/brew

BREW_TAPS=(
  jesseduffield/lazydocker
)

BREW_PACKAGES=(
  devcontainer
  lazydocker
)

brew_as_user() {
  setpriv --reuid=1000 --regid=1000 --clear-groups \
    env HOME="${BREW_HOME}" "${BREW_BIN}" "$@"
}

for tap in "${BREW_TAPS[@]}"; do
  brew_as_user tap "${tap}"
done

brew_as_user install --ignore-dependencies "${BREW_PACKAGES[@]}"
