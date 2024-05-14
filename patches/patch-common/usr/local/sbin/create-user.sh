#!/bin/bash

USERNAME=$1
USERID=$2
IS_ADMIN=$3

function present_groups() {
	for GROUP in $@
	do
		grep -o "^$GROUP:" /etc/group | tr -d ':'
	done
}

adduser --uid $USERID --disabled-password --gecos "" $USERNAME

if test "${IS_ADMIN}" = yes
then
	for GROUP in $(present_groups adm cdrom sudo dip plugdev lpadmin)
	do
		adduser $USERNAME $GROUP
	done
fi

cp -a --update=none /etc/skel/. /home/$USERNAME

chown -R $USERNAME:$USERNAME /home/$USERNAME

exit 0
