#!/bin/bash -e

	echo -n "Fix Battery Charge Rate: "
		echo 'KERNEL=="axp20x-battery", ATTR{constant_charge_current_max}="2200000", ATTR{constant_charge_current}="2000000"' >> "${ROOTFS_DIR}/etc/udev/rules.d/99-uconsole-charging.rules"
		echo "OK"
	rm -rf "${ROOTFS_DIR}/control_template"