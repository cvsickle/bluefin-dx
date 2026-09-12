#!/usr/bin/env bash
set -euo pipefail

# Install just
curl -fsSL https://just.systems/install.sh | sudo bash -s -- --to /usr/local/bin
sudo tee /usr/local/bin/ujust >/dev/null <<'EOF'
#!/bin/bash
just --justfile /workspaces/bluefin-dx-nvidia-open/justfile "$@"
EOF
sudo chmod +x /usr/local/bin/ujust

# Install cosign
curl -fsSL \
    "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64" \
    | sudo tee /usr/local/bin/cosign >/dev/null
sudo chmod +x /usr/local/bin/cosign

# Install bluebuild CLI
curl -fsSL https://raw.githubusercontent.com/blue-build/cli/main/install.sh | sudo bash
command -v bluebuild
bluebuild --version
