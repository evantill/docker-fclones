#!/usr/bin/env sh
set -euo pipefail

BASEDIR=$(dirname $0)

DEFAULT_INSTALL_DIR="$HOME/.local/bin"
export INSTALL_DIR="${INSTALL_DIR:-$DEFAULT_INSTALL_DIR}"

DEFAULT_INSTALL_BIN="$INSTALL_DIR/fclones"
export INSTALL_BIN="${INSTALL_BIN:-$DEFAULT_INSTALL_BIN}"

installScript(){
  if test -f "${INSTALL_BIN}"; then
    echo "$INSTALL_BIN already exist"
    exit 1
  else
    cp "$BASEDIR/fclones.sh" "$INSTALL_BIN"
	  echo "$INSTALL_BIN has been installed"
  fi
}

uninstallScript(){
  if test -f "$INSTALL_BIN"; then
    rm "$INSTALL_BIN"
    echo "$INSTALL_BIN has been removed"
  fi
}

run_target_in_docker(){
  docker run --rm -it \
    -e INSTALL_DIR="/install" \
    -e INSTALL_BIN \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$PWD:$PWD" \
    -v "$INSTALL_DIR:/install" \
    -w "$PWD" \
    flemay/musketeers make "$@"
}

for target in "$@"
do
  case "$target" in
    (installScript)
      installScript
      ;;
    (uninstallScript)
      uninstallScript
      ;;
    (*)
      run_target_in_docker "$@"
      ;;
  esac
done
