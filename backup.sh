#!/sbin/env bash

PROGNAME="$0"

help() {
    echo "Usage: $PROGNAME PATHLINK [PATHLINK...]" >&2
    echo "PATHLINK should be symbolic link to mounted btrfs subvolume" >&2
}

if [[ $# < 1 ]]; then
    help
    exit 1
fi

CODE=0

for path in "$@"; do
    if [[ ! -L "$path" ]]; then
        echo "$path is not a symbolic link" >&2
        CODE=1
        continue
    fi

    PREFIX="$(basename "$path")"
    ROOT="$(readlink -f "$path")"
    if [[ ! -d "$ROOT" ]]; then
        echo "$ROOT is not a directory" >&2
        CODE=1
        continue
    fi

    if ! makebackup "$PREFIX" "$ROOT"; then
        CODE=1
    fi
done

exit $CODE
