#!/bin/bash

set -e

echo 'Binary::apt::APT::Keep-Downloaded-Packages "1";' > /etc/apt/apt.conf.d/10apt-keep-downloads

echo "deb http://deb.debian.org/debian $(. /etc/os-release && echo "$VERSION_CODENAME") main contrib non-free non-free-firmware" > /etc/apt/sources.list
echo "deb http://deb.debian.org/debian $(. /etc/os-release && echo "$VERSION_CODENAME")-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list
echo "deb http://security.debian.org/debian-security $(. /etc/os-release && echo "$VERSION_CODENAME")-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list

dpkg --add-architecture i386

apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

depends=(
)

depends+=(
	linux-image-amd64
	linux-headers-amd64
)

depends+=(
	busybox
	sudo
)

depends+=(
	squashfs-tools
)

depends+=(
	${MAIN_PACKAGE}
)

apt-get install -y ${depends[*]}

for PKGBUILD in $(find . -maxdepth 1 -type f -name 'PKGBUILD-*' | sort)
do
	depends=(
	)

	source $PKGBUILD

	apt-get install -y ${depends[*]}
done

for PKG in $(find debs -maxdepth 1 -type f -name '*.deb' | sort)
do
	apt install -y $(pwd)/$PKG
done

apt-get install -y gpg software-properties-common wget

for SCRIPT in $(find packages.sh.d -maxdepth 1 -type f -name '*.sh' | sort)
do
	$SCRIPT
done

apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get autoremove -y

apt-mark -y minimize-manual
update-initramfs -u
