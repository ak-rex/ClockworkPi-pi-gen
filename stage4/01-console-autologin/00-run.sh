#!/bin/bash -e

on_chroot << EOF
	SUDO_USER="${FIRST_USER_NAME}" raspi-config nonint do_boot_behaviour B4
	SUDO_USER="${FIRST_USER_NAME}" apt -y remove agnostics
	SUDO_USER="${FIRST_USER_NAME}" apt -y autoremove
EOF
