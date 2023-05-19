#!/sbin/env bash

PROGNAME=$0

if [[ $# < 2 ]]; then
    (
        echo "Usage: $PROGNAME PREFIX PATH"
    ) >&2
    exit 1
fi

PREFIX=$1
ROOT=$2

TOP=$(btrfs subvolume show -b "$ROOT" | grep -Po '(?<=^\tTop level ID: \t\t)(\d+)$')
(($?)) && exit 1
BLOCK=$(awk '$2=="'"$ROOT"'"{print$1}' /proc/mounts)
if (($?)) || [[ -z $BLOCK ]]; then
    echo "cant find block device for $ROOT" >&2
    exit 1
fi

ROOT_PATH=$(mktemp -d /tmp/makebackup.XXXXX)
trap "rmdir '$ROOT_PATH'" EXIT

mount -osubvolid="$TOP" -tbtrfs "$BLOCK" "$ROOT_PATH"
(($?)) && exit 1
trap "umount '$ROOT_PATH'; rmdir '$ROOT_PATH'" EXIT

SNAPSHOT_NAME=@"$PREFIX"-"$(date +%F)"
SNAPSHOT_PATH=$ROOT_PATH/$SNAPSHOT_NAME

if [[ -d $SNAPSHOT_PATH ]]; then
    echo "Snapshot $SNAPSHOT_NAME already exists" >&2
else
    echo "Backuping $ROOT at $SNAPSHOT_NAME"
    if ! btrfs subvolume snapshot -r "$ROOT" "$SNAPSHOT_PATH" >/dev/null 2>/dev/null; then
        echo "Cannot create backup $ROOT at $SNAPSHOT_NAME" >&2
        exit 1
    fi
fi
