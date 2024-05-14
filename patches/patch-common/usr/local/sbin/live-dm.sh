#!/bin/bash

SESSION=$(test "$WAYLAND" = yes && test -d /usr/share/wayland-sessions && find /usr/share/wayland-sessions -maxdepth 1 -type f -name '*.desktop' -exec basename {} \; | tail -n 1 | sed 's/\.desktop$//')
if test -z "$SESSION"
then
	SESSION=$(test -d /usr/share/xsessions && find /usr/share/xsessions -maxdepth 1 -type f -name '*.desktop' -exec basename {} \; | tail -n 1 | sed 's/\.desktop$//')
fi

if test -f /usr/lib/systemd/system/sddm.service
then
	if test "$AUTOLOGIN" = yes
	then
		echo > /etc/sddm.conf

		mkdir -p /etc/sddm.conf.d

		cat > /etc/sddm.conf.d/kde_settings.conf << EOF
[Autologin]
Relogin=false
Session=$SESSION
User=$USERNAME

[General]
HaltCommand=
RebootCommand=

[Theme]
Current=

[Users]
MaximumUid=60000
MinimumUid=1000
EOF
	fi

elif test -f /usr/lib/systemd/system/gdm.service
then
	if test "$AUTOLOGIN" = yes
	then
		cat > /etc/gdm3/custom.conf << EOF
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=$USERNAME
EOF
	fi

fi

exit 0
