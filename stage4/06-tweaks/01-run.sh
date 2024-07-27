#!/bin/sh -e

	echo -n "Copying Files: "
		cp -r files/usr/* "${ROOTFS_DIR}/usr/"
		echo "Done"

	echo -n "Configuring system theme: "
		mkdir -p "${ROOTFS_DIR}/etc/skel/.config"
		mkdir -p "${ROOTFS_DIR}/var/lib/lightdm/.config/"
	for d in "${ROOTFS_DIR}/home/"* ; do
		cp -r files/user/.config/* "${ROOTFS_DIR}/etc/skel/.config/"
		cp -r files/user/.config/* "${ROOTFS_DIR}/var/lib/lightdm/.config/"
		cp -r files/user/.config/* "$d/.config/"
		chown -R 1000:1000 "$d/.config"
		chown -R 106:111 "${ROOTFS_DIR}/var/lib/lightdm/"
	done
		echo "Done"

	echo -n "Configuring LightDM Screen Rotation: "
		sed -i '/^#greeter-setup-script=/c\greeter-setup-script=/etc/lightdm/setup.sh' "${ROOTFS_DIR}/etc/lightdm/lightdm.conf"
		echo '#!/bin/sh' >"${ROOTFS_DIR}/etc/lightdm/setup.sh"
		echo 'wlr-randr --output DSI-1 --transform 270' >>"${ROOTFS_DIR}/etc/lightdm/setup.sh"
		echo 'exit 0' >>"${ROOTFS_DIR}/etc/lightdm/setup.sh"
		chmod +x "${ROOTFS_DIR}/etc/lightdm/setup.sh"
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
