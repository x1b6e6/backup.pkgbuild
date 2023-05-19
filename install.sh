#!/sbin/env bash

PREFIX=${PREFIX:-/usr/local}
DESTDIR=${DESTDIR:-}

mkdir -p "$DESTDIR"/etc/backup/
mkdir -p "$DESTDIR$PREFIX"/bin

install -m755 shallowbackups.sh "$DESTDIR$PREFIX"/bin/shallowbackups
install -m755 makebackup.sh "$DESTDIR$PREFIX"/bin/makebackup
