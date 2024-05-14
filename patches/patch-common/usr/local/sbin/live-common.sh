#!/bin/bash

rm -f /etc/localtime
ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime

echo $HOSTNAME > /etc/hostname
echo 127.0.0.1 localhost >> /etc/hosts
echo 127.0.0.1 $HOSTNAME >> /etc/hosts

echo "$LOCALE.UTF-8 UTF-8" > /etc/locale.gen
locale-gen

echo "LANG=$LOCALE.UTF-8" > /etc/locale.conf

systemctl enable live-sync

test -f /usr/lib/systemd/system/man-db.timer && systemctl disable man-db.timer
test -f /usr/lib/systemd/system/casper-md5check.service && systemctl disable casper-md5check.service

exit 0
