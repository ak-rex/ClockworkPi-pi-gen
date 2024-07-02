#!/bin/bash -e

on_chroot << EOF

	echo -n "Installing RetroPie: "
	if [[ -d "/home/pi/RetroPie-Setup" ]]; then
		echo "Already Installed"
		cd home/pi/RetroPie-Setup
		./retropie_setup.sh
	else
		cd home/pi
		git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git
		cd RetroPie-Setup
		__nodialog=1 ./retropie_packages.sh setup basic_install
		echo "RetroPie Install: Complete"
	fi

	raspi-config nonint do_boot_behaviour B2
EOF
	echo -n "Configuring RetroPie : "
		cp -r files/pix "${ROOTFS_DIR}/usr/share/plymouth/themes/"
		cp files/plymouthd.conf "${ROOTFS_DIR}/etc/plymouth/"
		cp files/es_systems.cfg "${ROOTFS_DIR}/etc/emulationstation/es_systems.cfg"
		cp files/es_input.cfg "${ROOTFS_DIR}/opt/retropie/configs/all/emulationstation/es_input.cfg"
		cp files/es_settings.cfg "${ROOTFS_DIR}/opt/retropie/configs/all/emulationstation/es_settings.cfg"
		cp -r files/controllers/* "${ROOTFS_DIR}/opt/retropie/configs/all/retroarch/autoconfig/"
		cp files/retroarch.cfg "${ROOTFS_DIR}/opt/retropie/configs/all/retroarch.cfg"
		cp files/retropie-device "${ROOTFS_DIR}/usr/local/bin/retropie-device"
		cp files/uconsole.conf "${ROOTFS_DIR}/etc/triggerhappy/triggers.d/uconsole.conf"
	echo "Done"