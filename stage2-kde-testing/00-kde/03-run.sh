#!/bin/bash -e


cp -r files/autostart "${ROOTFS_DIR}/etc/skel/.config/"

on_chroot <<EOF
	systemctl set-default graphical.target
	SUDO_USER="${FIRST_USER_NAME}" raspi-config nonint do_vnc 1


EOF
#	echo "pi ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/pi > /dev/null && sudo chmod 0440 /etc/sudoers.d/pi && sudo visudo -c
#	echo "rpi-first-boot-wizard ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/rpi-first-boot-wizard > /dev/null && sudo chmod 0440 /etc/sudoers.d/rpi-first-boot-wizard && sudo visudo -c
#	adduser "${FIRST_USER_NAME}" lpadmin