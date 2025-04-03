#!/bin/sh
echo -ne '\033c\033]0;realm of rhytm\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/linuxplay.x86_64" "$@"
