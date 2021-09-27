#!/usr/bin/env sh
set -euo pipefail

DEFAULT_INSTALL_DIR="$HOME/.local/bin"
export INSTALL_DIR="${INSTALL_DIR:-$DEFAULT_INSTALL_DIR}"

DEFAULT_INSTALL_BIN="$INSTALL_DIR/fclones"
export INSTALL_BIN="${INSTALL_BIN:-$DEFAULT_INSTALL_BIN}"

docker run --rm -it \
  -e INSTALL_DIR -e INSTALL_BIN \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$PWD:$PWD" \
  -v "$INSTALL_DIR:$INSTALL_DIR" \
  -w "$PWD" \
  flemay/musketeers make "$@"
