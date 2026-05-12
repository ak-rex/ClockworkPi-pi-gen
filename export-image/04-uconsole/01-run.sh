#!/bin/bash -e

	echo -n "Configuring LightDM theme: "
	if [[ -d "${ROOTFS_DIR}/etc/lightdm" ]]; then
		for d in "${ROOTFS_DIR}/home/"* ; do
			mkdir -p "${ROOTFS_DIR}/var/lib/lightdm/.config/"
			cp -r files/user/.config/* "${ROOTFS_DIR}/var/lib/lightdm/.config/"
			echo '[greeter]' > "${ROOTFS_DIR}/etc/lightdm/pi-greeter.conf"
			echo 'default-user-image=/usr/share/raspberrypi-artwork/clockworkpi.png' >> "${ROOTFS_DIR}/etc/lightdm/pi-greeter.conf"
			echo 'desktop_bg=#000000' >> "${ROOTFS_DIR}/etc/lightdm/pi-greeter.conf"
			echo 'wallpaper=/usr/share/rpd-wallpaper/RPiSystemBlack.png' >> "${ROOTFS_DIR}/etc/lightdm/pi-greeter.conf"
			echo 'wallpaper_mode=center' >> "${ROOTFS_DIR}/etc/lightdm/pi-greeter.conf"
			echo 'gtk-icon-theme-name=PiXflat' >> "${ROOTFS_DIR}/etc/lightdm/pi-greeter.conf"
			echo 'gtk-font-name=PibotoLt 12' >> "${ROOTFS_DIR}/etc/lightdm/pi-greeter.conf"
		done
			echo "Done"
	else
			echo "Skipped"
	fi

	echo -n "Configuring labwc: "
	if [[ -d "${ROOTFS_DIR}/etc/xdg/labwc-greeter" ]]; then
		for d in "${ROOTFS_DIR}/home/"* ; do
			owner_id=$(stat -c '%u' "$d")
			mkdir -p "$d/.config"
			cp -r files/user/.* "$d/"
			chown -R $owner_id "$d/.config"
			mkdir -p "${ROOTFS_DIR}/etc/skel/.config"
			cp -r files/user/.config/* "${ROOTFS_DIR}/etc/skel/.config/"
			sed -i '1 a wlr-randr --output DSI-1 --transform 270 &' "${ROOTFS_DIR}/etc/xdg/labwc-greeter/autostart"
			sed -i '2 a wlr-randr --output DSI-2 --transform 270 &' "${ROOTFS_DIR}/etc/xdg/labwc-greeter/autostart"
		done
			echo "Done"
	else
			echo "Skipped"
	fi

	echo -n "Configuring Wayfire OSD: "
	if [[ -d "${ROOTFS_DIR}/etc/wayfire" ]]; then
			sed -i '1 a binding_light_up=KEY_BRIGHTNESSUP' "${ROOTFS_DIR}/etc/wayfire/template.ini"
			sed -i '2 a command_light_up=brightnessctl s +1 && ~/.config/brightness_osd.sh' "${ROOTFS_DIR}/etc/wayfire/template.ini"
			sed -i '3 a binding_light_down=KEY_BRIGHTNESSDOWN' "${ROOTFS_DIR}/etc/wayfire/template.ini"
			sed -i '4 a command_light_down=brightnessctl s 1- && ~/.config/brightness_osd.sh' "${ROOTFS_DIR}/etc/wayfire/template.ini"
			sed -i '/^repeatable_binding_volume_up = KEY_VOLUMEUP/c\binding_volume_up=KEY_VOLUMEUP' "${ROOTFS_DIR}/etc/wayfire/template.ini"
			sed -i '/^command_volume_up = wfpanelctl volumepulse volu/c\command_volume_up=wfpanelctl volumepulse volu && ~/.config/volume_osd.sh' "${ROOTFS_DIR}/etc/wayfire/template.ini"
			sed -i '/^repeatable_binding_volume_down = KEY_VOLUMEDOWN/c\binding_volume_down=KEY_VOLUMEDOWN' "${ROOTFS_DIR}/etc/wayfire/template.ini"
			sed -i '/^command_volume_down = wfpanelctl volumepulse vold/c\command_volume_down=wfpanelctl volumepulse vold && ~/.config/volume_osd.sh' "${ROOTFS_DIR}/etc/wayfire/template.ini"
			echo "Done"
	else
			echo "Skipped"
	fi

	echo -n "Configuring SDDM: "
	if [[ -d "${ROOTFS_DIR}/etc/" ]]; then
			mkdir -p "${ROOTFS_DIR}/etc/sddm.conf.d"
			touch "${ROOTFS_DIR}/etc/sddm.conf.d/autologin.conf"
			touch "${ROOTFS_DIR}/etc/sddm.conf.d/rotation.conf"
			touch "${ROOTFS_DIR}/etc/sddm.conf.d/display.conf"
#			echo "[Autologin]" > "${ROOTFS_DIR}/etc/sddm.conf.d/autologin.conf"
#			echo "User=pi" >> "${ROOTFS_DIR}/etc/sddm.conf.d/autologin.conf"
#			echo "Session=plasma.desktop" >> "${ROOTFS_DIR}/etc/sddm.conf.d/autologin.conf"
			echo "[X11]" > "${ROOTFS_DIR}/etc/sddm.conf.d/rotation.conf"
			echo "DisplayCommand=/usr/local/bin/sddm-rotate" >>"${ROOTFS_DIR}/etc/sddm.conf.d/rotation.conf"
			echo "[General]" > "${ROOTFS_DIR}/etc/sddm.conf.d/display.conf"
			echo "DisplayServer=x11" >> "${ROOTFS_DIR}/etc/sddm.conf.d/display.conf"
			cp -r files/sddm/sddm-rotate "${ROOTFS_DIR}/usr/local/bin/sddm-rotate"
			cp -r files/sddm/run-piwiz-once "${ROOTFS_DIR}/usr/local/bin/sddm-rotate"
			cp -r files/sddm/.* "${ROOTFS_DIR}/etc/skel/"
#on_chroot <<EOF
#	systemctl mask userconf-pi.service
#EOF
#			cp -r files/lightdm/setup.sh "${ROOTFS_DIR}/etc/lightdm/setup.sh"
#			sed -i '/^#greeter-setup-script=/c\greeter-setup-script=/etc/lightdm/setup.sh' "${ROOTFS_DIR}/etc/lightdm/lightdm.conf"
#			sed -i '/^#greeter-hide-users=false/c\greeter-hide-users=false' "${ROOTFS_DIR}/etc/lightdm/lightdm.conf"
#			sed -i '/^user-session=rpd-labwc/c\user-session=startplasma-wayland' "${ROOTFS_DIR}/etc/lightdm/lightdm.conf"
#			sed -i '/^Exec=piwiz/c\Exec=piwiz && sed -i '/^autologin-session=rpd-labwc/c\autologin-session=startplasma-wayland' "${ROOTFS_DIR}/etc/lightdm/lightdm.conf"' "${ROOTFS_DIR}/etc/xdg/autostart/piwiz.desktop"
#			sed -i '/^autologin-session=rpd-labwc/c\autologin-session=startplasma-wayland' "${ROOTFS_DIR}/etc/lightdm/lightdm.conf"
			echo "Done"
	else
			echo "Skipped"
	fi

	echo -n "Configuring RetroPie Screen Rotation: "
	if [[ -d "${ROOTFS_DIR}/home/pi/RetroPie" ]]; then
		for d in "${ROOTFS_DIR}/home/"* ; do
			owner_id=$(stat -c '%u' "$d")
			mkdir -p "${ROOTFS_DIR}/etc/skel/RetroPie"
			cp -r files/RetroPie/.* "${ROOTFS_DIR}/etc/skel/"
			cp -r files/RetroPie/RetroPie "${ROOTFS_DIR}/etc/skel/"
			cp -r files/RetroPie/.* "$d/"
			cp -r files/RetroPie/RetroPie "$d/"
			chown -R 1000:1000 "${ROOTFS_DIR}/opt/retropie/configs"
			sed -i '1s/$/ splash plymouth.ignore-serial-consoles/' "${ROOTFS_DIR}/boot/firmware/cmdline.txt"
		done
			echo "Done"
	else
			echo "Skipped"
	fi

	echo -n "Configuring X11 Screen Rotation: "
	if [[ -d "${ROOTFS_DIR}/etc/X11" ]]; then
			echo "xrandr --output DSI-1 --transform 270" > "${ROOTFS_DIR}/etc/X11/Xsession.d/100custom_xrandr"
			echo "xrandr --output DSI-2 --transform 270" >> "${ROOTFS_DIR}/etc/X11/Xsession.d/100custom_xrandr"
			echo "Done"
	else
			echo "Skipped"
	fi

	echo -n "Configuring Keyboard: "
on_chroot <<EOF
	SUDO_USER="${FIRST_USER_NAME}" raspi-config nonint do_configure_keyboard us
EOF
			echo "Keyboard Configuation Done"
