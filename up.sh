#!/bin/sh

set -e

if ! test $(id -u) = 0
then
	sudo $0
	exit $?
fi

cd $(dirname $0)

CWD=$(pwd)

remount() {
	while true
	do
		if mountpoint -q .
		then
			mount -o remount,$1 .
			break
		fi

		cd ..
	done

	cd $CWD
}

build() {
	local REF_FILE=.ref

	rm -f $REF_FILE
	touch $REF_FILE

	./base.sh
	find pkg-debootstrap -mindepth 1 -maxdepth 1 -not -neweraa $REF_FILE -exec rm -Rfv {} \;

	docker compose up --build
	docker compose down
	rm -Rfv pkg-system/partial
	rm -fv pkg-system/lock
	find pkg-system -mindepth 1 -maxdepth 1 -not -neweraa $REF_FILE -exec rm -Rfv {} \;
}

remount strictatime

mkdir -p out

build > out/build.log 2>&1

#remount relatime
