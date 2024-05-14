#!/bin/sh

if ! test $(id -u) = 0
then
	sudo $0
	exit $?
fi

cd $(dirname $0)

which debootstrap > /dev/null || exit 1

DISTRO=$(cat base.release)
MIRROR=http://mirrors.kernel.org/debian/

CWD=$(pwd)

TMPDIR=$(mktemp -d)

TARGET=$TMPDIR/base
mkdir $TARGET

mkdir -p $CWD/pkg-debootstrap

debootstrap --arch amd64 --cache-dir $CWD/pkg-debootstrap $DISTRO $TARGET $MIRROR

cd $TARGET
tar -zcpf $CWD/base.tar.gz .
cd $CWD

rm -Rf $TMPDIR
