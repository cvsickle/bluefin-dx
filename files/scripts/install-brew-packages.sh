#!/usr/bin/env bash

set -euo pipefail

STAGED_BREW_HOME=/usr/share/homebrew/home/linuxbrew
RUNTIME_BREW_HOME=/home/linuxbrew

BREW_TAPS=(
  jesseduffield/lazydocker
)

BREW_PACKAGES=(
  devcontainer
  lazydocker
)

brew_as_user() {
  if [[ "$(id -u)" == 1000 ]]; then
    env HOME="${BREW_USER_HOME}" "${BREW_BIN}" "$@"
  else
    setpriv --reuid=1000 --regid=1000 --clear-groups \
      env HOME="${BREW_USER_HOME}" "${BREW_BIN}" "$@"
  fi
}

if [[ -x "${RUNTIME_BREW_HOME}/.linuxbrew/bin/brew" ]]; then
  BREW_HOME=${RUNTIME_BREW_HOME}
  BREW_USER_HOME=$(getent passwd 1000 | cut -d: -f6)
elif [[ -x "${STAGED_BREW_HOME}/.linuxbrew/bin/brew" ]]; then
  BREW_HOME=${STAGED_BREW_HOME}
  BREW_USER_HOME=${STAGED_BREW_HOME}
else
  echo "Homebrew installation was not found" >&2
  exit 1
fi

BREW_BIN=${BREW_HOME}/.linuxbrew/bin/brew

if [[ -z "${BREW_USER_HOME}" ]]; then
  echo "Home directory for UID 1000 was not found" >&2
  exit 1
fi

for tap in "${BREW_TAPS[@]}"; do
  brew_as_user tap "${tap}"
  brew_as_user trust "${tap}"
done

if [[ "${BREW_HOME}" == "${STAGED_BREW_HOME}" ]]; then
  brew_as_user install --ignore-dependencies "${BREW_PACKAGES[@]}"
  systemctl enable bluefin-brew-packages.service
else
  brew_as_user install --only-dependencies "${BREW_PACKAGES[@]}"
  brew_as_user install "${BREW_PACKAGES[@]}"
fi
