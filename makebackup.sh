#!/sbin/env bash

if [[ $# < 2 ]]; then
    (
        echo "Usage:"
        echo "  $0 PREFIX PATH [KEEPCOUNT]"
        echo
        echo "KEEPCOUNT = 10 by default"
        echo
    ) >&2
    exit 1
fi

PREFIX="$1"
ROOT="$2"
KEEPCOUNT=${3:-${KEEPCOUNT:-10}}

TOP="$(btrfs subvolume show -b "$ROOT" | grep -Po '(?<=^\tTop level ID: \t\t)(\d+)$')"
(($?)) && exit 1
BLOCK="$(awk '$2=="'"$ROOT"'"{print$1}' /proc/mounts)"
if (($?)) || [[ -z $BLOCK ]]; then
    echo "cant find block device for $ROOT" >&2
    exit 1
fi

ROOT_PATH="$(mktemp -d /tmp/makebackup.XXXXX)"
trap "rmdir '$ROOT_PATH'" EXIT

mount -osubvolid="$TOP" -tbtrfs "$BLOCK" "$ROOT_PATH"
(($?)) && exit 1
trap "umount '$ROOT_PATH'; rmdir '$ROOT_PATH'" EXIT

SNAPSHOT_NAME=@"$PREFIX"-"$(date +%F)"
SNAPSHOT_PATH="$ROOT_PATH"/"$SNAPSHOT_NAME"

if [[ -d $SNAPSHOT_PATH ]]; then
    echo "Snapshot $SNAPSHOT_NAME already exists" >&2
else
    echo "Backuping $ROOT at $SNAPSHOT_NAME"
    if ! btrfs subvolume snapshot -r "$ROOT" "$SNAPSHOT_PATH" >/dev/null 2>/dev/null; then
        echo "Cannot create backup $ROOT at $SNAPSHOT_NAME" >&2
        exit 1
    fi
fi

btrfs subvolume list --sort=-path "$ROOT" | awk '$9~/^@'"$PREFIX"'-/{print$2" "$9}' | awk "NR>$KEEPCOUNT" | while read -r LINE; do
    ID=$(echo "$LINE" | grep -Po '^\d+')
    NAME=$(echo "$LINE" | grep -Po '(?<= ).*')
    btrfs subvolume delete -i "$ID" "$ROOT"
done
