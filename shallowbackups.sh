#!/sbin/env bash

PROGNAME=$0

if [[ $# < 2 ]]; then
    (
        echo "Usage: $PROGNAME PREFIX PATH [KEEPCOUNT]"
        echo "KEEPCOUNT 10 by default"
    ) >&2
    exit 1
fi

PREFIX=$1
ROOT=$2
KEEPCOUNT=${3:-${KEEPCOUNT:-10}}

btrfs subvolume list --sort=-path "$ROOT" \
        | awk '$9~/^@'"$PREFIX"'-[0-9]{4}-[0-9]{2}-[0-9]{2}$/{print$2}' \
        | awk "NR>$KEEPCOUNT" \
        | while read -r ID; do
    btrfs subvolume delete -i "$ID" "$ROOT"
done
