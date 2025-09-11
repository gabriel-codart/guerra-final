#!/bin/sh
echo -ne '\033c\033]0;Nova Gênese\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Nova Genese v0.01 - Linux.x86_64" "$@"
