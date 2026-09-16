#!/usr/bin/env bash

set -euo pipefail

readonly installer_url="https://raw.githubusercontent.com/yorukot/superfile/main/website/public/install.sh"

curl --fail --silent --show-error --location --retry 3 "$installer_url" | bash

