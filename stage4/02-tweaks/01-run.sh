#!/bin/sh -e

	echo -n "Copying Files: "
		cp -rf files/usr/* "${ROOTFS_DIR}/usr/"
		echo "Done"

	echo -n "Configuring system theme: "
		mkdir -p "${ROOTFS_DIR}/var/lib/lightdm/.config/"
	for d in "${ROOTFS_DIR}/home/"* ; do
		cp -r files/user/.config/* "${ROOTFS_DIR}/var/lib/lightdm/.config/"
	done
		echo "Done"

	echo -n "Setting up LightDM: "
		echo '[greeter]' > "${ROOTFS_DIR}/etc/lightdm/pi-greeter.conf"
		echo 'default-user-image=/usr/share/raspberrypi-artwork/clockworkpi.png' >> "${ROOTFS_DIR}/etc/lightdm/pi-greeter.conf"
		echo 'desktop_bg=#000000' >> "${ROOTFS_DIR}/etc/lightdm/pi-greeter.conf"
		echo 'wallpaper=/usr/share/rpd-wallpaper/RPiSystemBlack.png' >> "${ROOTFS_DIR}/etc/lightdm/pi-greeter.conf"
		echo 'wallpaper_mode=center' >> "${ROOTFS_DIR}/etc/lightdm/pi-greeter.conf"
		echo 'gtk-icon-theme-name=PiXflat' >> "${ROOTFS_DIR}/etc/lightdm/pi-greeter.conf"
		echo 'gtk-font-name=PibotoLt 12' >> "${ROOTFS_DIR}/etc/lightdm/pi-greeter.conf"
		echo "Done"

	echo -n "Setting up OSD: "
		for d in "${ROOTFS_DIR}/home/"* ; do
			owner_id=$(stat -c '%u' "$d")
			cp -f files/OSD/* "$d/.config"
		done
		echo "Done"