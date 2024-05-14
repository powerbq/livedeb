#!/bin/sh

set -e

cd out

FILENAME=live_latest.squashfs

rm -f $FILENAME

mksquashfs / $FILENAME -ef ../excludes.txt -wildcards -no-xattrs -no-progress -comp zstd
sha256sum $FILENAME > $FILENAME.sha256sum

cat /vmlinuz > vmlinuz
cat /initrd.img > initrd.img
