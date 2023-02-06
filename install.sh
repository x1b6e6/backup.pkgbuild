#!/sbin/env bash

PREFIX=${PREFIX:-/usr/local}
DESTDIR=${DESTDIR:-}

mkdir -p "$DESTDIR"/etc/backup/
mkdir -p "$DESTDIR$PREFIX"/bin
mkdir -p "$DESTDIR$PREFIX"/lib/systemd/system

install -m755 backup.sh "$DESTDIR$PREFIX"/bin/backup
install -m755 makebackup.sh "$DESTDIR$PREFIX"/bin/makebackup
install -m644 backup@.service "$DESTDIR$PREFIX"/lib/systemd/system/backup@.service
