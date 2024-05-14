#!/bin/bash

if test -f /usr/lib/systemd/system/ssh.service && test "${ENABLE_SSH}" = yes
then
	systemctl enable ssh
fi

exit 0
