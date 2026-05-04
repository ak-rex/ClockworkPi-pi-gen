#!/bin/sh -e

	echo -n "Copying Files: "
		cp -rf files/usr/* "${ROOTFS_DIR}/usr/"
		echo "Done"

	echo -n "Setting up OSD: "
		for d in "${ROOTFS_DIR}/home/"* ; do
			owner_id=$(stat -c '%u' "$d")
			cp -f files/OSD/* "$d/.config"
		done
		echo "Done"