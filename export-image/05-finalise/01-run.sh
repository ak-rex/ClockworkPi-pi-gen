#!/bin/bash -e

IMG_FILE="${STAGE_WORK_DIR}/${IMG_FILENAME}${IMG_SUFFIX}.img"
INFO_FILE="${STAGE_WORK_DIR}/${IMG_FILENAME}${IMG_SUFFIX}.info"
SBOM_FILE="${STAGE_WORK_DIR}/${IMG_FILENAME}${IMG_SUFFIX}.sbom"
BMAP_FILE="${STAGE_WORK_DIR}/${IMG_FILENAME}${IMG_SUFFIX}.bmap"

on_chroot << EOF
update-initramfs -k all -c
if [ -x /etc/init.d/fake-hwclock ]; then
	/etc/init.d/fake-hwclock stop
fi
if hash hardlink 2>/dev/null; then
	hardlink -t /usr/share/doc
fi
EOF

if [ -f "${ROOTFS_DIR}/etc/initramfs-tools/update-initramfs.conf" ]; then
	sed -i 's/^update_initramfs=.*/update_initramfs=yes/' "${ROOTFS_DIR}/etc/initramfs-tools/update-initramfs.conf"
	sed -i 's/^MODULES=.*/MODULES=dep/' "${ROOTFS_DIR}/etc/initramfs-tools/initramfs.conf"
fi

if [ -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config" ]; then
	chmod 700 "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config"
fi

rm -f "${ROOTFS_DIR}/usr/bin/qemu-arm-static"

if [ "${USE_QEMU}" != "1" ]; then
	if [ -e "${ROOTFS_DIR}/etc/ld.so.preload.disabled" ]; then
		mv "${ROOTFS_DIR}/etc/ld.so.preload.disabled" "${ROOTFS_DIR}/etc/ld.so.preload"
	fi
fi

rm -f "${ROOTFS_DIR}/etc/network/interfaces.dpkg-old"

rm -f "${ROOTFS_DIR}/etc/apt/sources.list~"
rm -f "${ROOTFS_DIR}/etc/apt/trusted.gpg~"

rm -f "${ROOTFS_DIR}/etc/passwd-"
rm -f "${ROOTFS_DIR}/etc/group-"
rm -f "${ROOTFS_DIR}/etc/shadow-"
rm -f "${ROOTFS_DIR}/etc/gshadow-"
rm -f "${ROOTFS_DIR}/etc/subuid-"
rm -f "${ROOTFS_DIR}/etc/subgid-"

rm -f "${ROOTFS_DIR}"/var/cache/debconf/*-old
rm -f "${ROOTFS_DIR}"/var/lib/dpkg/*-old

rm -f "${ROOTFS_DIR}"/usr/share/icons/*/icon-theme.cache

rm -f "${ROOTFS_DIR}/var/lib/dbus/machine-id"

true > "${ROOTFS_DIR}/etc/machine-id"

ln -nsf /proc/mounts "${ROOTFS_DIR}/etc/mtab"

find "${ROOTFS_DIR}/var/log/" -type f -exec cp /dev/null {} \;

rm -f "${ROOTFS_DIR}/root/.vnc/private.key"
rm -f "${ROOTFS_DIR}/etc/vnc/updateid"


	echo -n "Configuring Desktop: "
	if [[ -d "${ROOTFS_DIR}/etc/wayfire" ]]; then
		for d in "${ROOTFS_DIR}/home/"* ; do
			owner_id=$(stat -c '%u' "$d")
			mkdir -p "$d/.config"
			cp -r files/user/.* "$d/"
			chown -R $owner_id "$d/.config"
		done
			echo "Done"

	echo -n "Configuring Wayland Screen Rotation: "
		echo '[output:DSI-1]' >> "${ROOTFS_DIR}/etc/wayfire/template.ini"
		echo 'mode = 480x1280@60000' >> "${ROOTFS_DIR}/etc/wayfire/template.ini"
		echo 'position = 0,0' >> "${ROOTFS_DIR}/etc/wayfire/template.ini"
		echo 'transform = 270' >> "${ROOTFS_DIR}/etc/wayfire/template.ini"
		echo '[input-device:wlr_virtual_pointer_v1]' >> "${ROOTFS_DIR}/etc/wayfire/template.ini"
		echo 'output = DSI-1' >> "${ROOTFS_DIR}/etc/wayfire/template.ini"
		sed -i '1 a wlr-randr --output DSI-1 --transform 270 &' "${ROOTFS_DIR}/etc/xdg/labwc-greeter/autostart"
		sed -i '2 a wlr-randr --output DSI-2 --transform 270 &' "${ROOTFS_DIR}/etc/xdg/labwc-greeter/autostart"
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
		echo "Done"
	else
		echo "Skipped"
	fi

update_issue "$(basename "${EXPORT_DIR}")"
install -m 644 "${ROOTFS_DIR}/etc/rpi-issue" "${ROOTFS_DIR}/boot/firmware/issue.txt"
if ! [ -L "${ROOTFS_DIR}/boot/issue.txt" ]; then
	ln -s firmware/issue.txt "${ROOTFS_DIR}/boot/issue.txt"
fi

cp "$ROOTFS_DIR/etc/rpi-issue" "$INFO_FILE"

{
	if [ -f "$ROOTFS_DIR/usr/share/doc/raspberrypi-kernel/changelog.Debian.gz" ]; then
		firmware=$(zgrep "firmware as of" \
			"$ROOTFS_DIR/usr/share/doc/raspberrypi-kernel/changelog.Debian.gz" | \
			head -n1 | sed  -n 's|.* \([^ ]*\)$|\1|p')
		printf "\nFirmware: https://github.com/raspberrypi/firmware/tree/%s\n" "$firmware"

		kernel="$(curl -s -L "https://github.com/raspberrypi/firmware/raw/$firmware/extra/git_hash")"
		printf "Kernel: https://github.com/raspberrypi/linux/tree/%s\n" "$kernel"

		uname="$(curl -s -L "https://github.com/raspberrypi/firmware/raw/$firmware/extra/uname_string7")"
		printf "Uname string: %s\n" "$uname"
	fi

	printf "\nPackages:\n"
	dpkg -l --root "$ROOTFS_DIR"
} >> "$INFO_FILE"

if hash syft 2>/dev/null; then
	syft scan dir:"${ROOTFS_DIR}" \
		--base-path="${ROOTFS_DIR}" \
		--source-name="${IMG_NAME}${IMG_SUFFIX}" \
		--source-version="${IMG_DATE}" \
		-o spdx-json="${SBOM_FILE}"
fi

ROOT_DEV="$(awk "\$2 == \"${ROOTFS_DIR}\" {print \$1}" /etc/mtab)"

unmount "${ROOTFS_DIR}"
zerofree "${ROOT_DEV}"

unmount_image "${IMG_FILE}"

if hash bmaptool 2>/dev/null; then
	bmaptool create \
		-o "${BMAP_FILE}" \
		"${IMG_FILE}"
fi

mkdir -p "${DEPLOY_DIR}"

rm -f "${DEPLOY_DIR}/${ARCHIVE_FILENAME}${IMG_SUFFIX}.*"
rm -f "${DEPLOY_DIR}/${IMG_FILENAME}${IMG_SUFFIX}.img"

case "${DEPLOY_COMPRESSION}" in
zip)
	pushd "${STAGE_WORK_DIR}" > /dev/null
	zip -"${COMPRESSION_LEVEL}" \
	"${DEPLOY_DIR}/${ARCHIVE_FILENAME}${IMG_SUFFIX}.zip" "$(basename "${IMG_FILE}")"
	popd > /dev/null
	;;
gz)
	pigz --force -"${COMPRESSION_LEVEL}" "$IMG_FILE" --stdout > \
	"${DEPLOY_DIR}/${ARCHIVE_FILENAME}${IMG_SUFFIX}.img.gz"
	;;
xz)
	xz --compress --force --threads 0 --memlimit-compress=50% -"${COMPRESSION_LEVEL}" \
	--stdout "$IMG_FILE" > "${DEPLOY_DIR}/${ARCHIVE_FILENAME}${IMG_SUFFIX}.img.xz"
	;;
none | *)
	cp "$IMG_FILE" "$DEPLOY_DIR/"
;;
esac

if [ -f "${SBOM_FILE}" ]; then
	xz -c "${SBOM_FILE}" > "$DEPLOY_DIR/$(basename "${SBOM_FILE}").xz"
fi
if [ -f "${BMAP_FILE}" ]; then
	cp "$BMAP_FILE" "$DEPLOY_DIR/"
fi
cp "$INFO_FILE" "$DEPLOY_DIR/"
