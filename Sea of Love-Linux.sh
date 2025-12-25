#!/bin/sh
printf '\033c\033]0;%s\a' Sea of Love
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Sea of Love-Linux.x86_64" "$@"
