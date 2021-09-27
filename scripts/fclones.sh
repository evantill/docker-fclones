#!/usr/bin/env sh
docker run --volume "$PWD:$PWD" --workdir "$PWD" --rm -it evantill/fclones:latest "$@"

