#!/bin/bash -e

true > "${ROOTFS_DIR}/etc/apt/sources.list"
install -m 644 files/ak-rex.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"
sed -i "s/RELEASE/${RELEASE}/g" "${ROOTFS_DIR}/etc/apt/sources.list.d/ak-rex.list"
cat files/ak-rex.gpg.key | gpg --dearmor > "${STAGE_WORK_DIR}/ak-rex.gpg"
install -m 644 "${STAGE_WORK_DIR}/ak-rex.gpg" "${ROOTFS_DIR}/etc/apt/trusted.gpg.d/"
on_chroot <<- \EOF
	ARCH="$(dpkg --print-architecture)"
	if [ "$ARCH" = "armhf" ]; then
		dpkg --add-architecture arm64
	elif [ "$ARCH" = "arm64" ]; then
		dpkg --add-architecture armhf
	fi
	apt-get update
	apt-get dist-upgrade -y
EOF
