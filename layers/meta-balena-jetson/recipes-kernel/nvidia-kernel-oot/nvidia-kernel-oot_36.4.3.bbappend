FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

inherit deploy

SRC_URI += "  \
    file://enable_80211d.patch \
"

# Add ATC3750-8M DTS patch for both 32GB and 64GB variants
SRC_URI:append:nexcom-atc3750-8m-agx-orin-32gb = " file://0001-dts-add-atc3750-8M-dts.patch"
SRC_URI:append:nexcom-atc3750-8m-agx-orin-64gb = " file://0001-dts-add-atc3750-8M-dts.patch"

SRC_URI:append:forecr-dsb-ornx-lan = " \
    file://forecr-dsb-ornx-lan/tegra234-p3768-0000+p3767-0000-dynamic.dtbo \
    file://forecr-dsb-ornx-lan/tegra234-p3767-camera-dsboard-ornx-imx219.dtbo \
    file://forecr-dsb-ornx-lan/tegra234-p3767-camera-dsboard-ornx-imx477.dtbo \
"

SRC_URI:append:nexcom-atc3750-8m-agx-orin-32gb = " \
    file://nexcom-atc3750-8m/tegra234-p3701-0004-atc3750-8M-base_ver.dtb \
"

SRC_URI:append:nexcom-atc3750-8m-agx-orin-64gb = " \
    file://nexcom-atc3750-8m/tegra234-p3701-0005-atc3750-8M-base_ver.dtb \
"

# Note tegra-...-dynamic.dtbo overwrites a file with the same name from Nvidia,
# but the camera overlays are new files
do_install:append:forecr-dsb-ornx-lan() {
    install -m 0644 \
        ${WORKDIR}/forecr-dsb-ornx-lan/tegra234-p3768-0000+p3767-0000-dynamic.dtbo \
        ${WORKDIR}/forecr-dsb-ornx-lan/tegra234-p3767-camera-dsboard-ornx-imx219.dtbo \
        ${WORKDIR}/forecr-dsb-ornx-lan/tegra234-p3767-camera-dsboard-ornx-imx477.dtbo \
        ${D}/boot/devicetree/
}

# Deploying is not necessary for Balena images, but meta-tegra does it
# so let's do it as well just for consistency.
do_deploy:append:forecr-dsb-ornx-lan() {
    install -m 0644 \
        ${WORKDIR}/forecr-dsb-ornx-lan/tegra234-p3768-0000+p3767-0000-dynamic.dtbo \
        ${WORKDIR}/forecr-dsb-ornx-lan/tegra234-p3767-camera-dsboard-ornx-imx219.dtbo \
        ${WORKDIR}/forecr-dsb-ornx-lan/tegra234-p3767-camera-dsboard-ornx-imx477.dtbo \
        ${DEPLOYDIR}/devicetree/
}

do_install:append:nexcom-atc3750-8m-agx-orin-32gb() {
    install -m 0644 \
        ${WORKDIR}/nexcom-atc3750-8m/tegra234-p3701-0004-atc3750-8M-base_ver.dtb \
        ${D}/boot/devicetree/
}

do_install:append:nexcom-atc3750-8m-agx-orin-64gb() {
    install -m 0644 \
        ${WORKDIR}/nexcom-atc3750-8m/tegra234-p3701-0005-atc3750-8M-base_ver.dtb \
        ${D}/boot/devicetree/
}

# Deploying is necessary for nvidia-kernel-oot-dtb to find the DTB files
do_deploy:append:nexcom-atc3750-8m-agx-orin-32gb() {
    install -m 0644 \
        ${WORKDIR}/nexcom-atc3750-8m/tegra234-p3701-0004-atc3750-8M-base_ver.dtb \
        ${DEPLOYDIR}/devicetree/
}

do_deploy:append:nexcom-atc3750-8m-agx-orin-64gb() {
    install -m 0644 \
        ${WORKDIR}/nexcom-atc3750-8m/tegra234-p3701-0005-atc3750-8M-base_ver.dtb \
        ${DEPLOYDIR}/devicetree/
}

# Set machine-specific architecture for Nexcom devices to ensure
# DTB files are deployed to the correct machine-specific work directory
PACKAGE_ARCH:nexcom-atc3750-8m-agx-orin-32gb = "${MACHINE_ARCH}"
PACKAGE_ARCH:nexcom-atc3750-8m-agx-orin-64gb = "${MACHINE_ARCH}"

# Base do_deploy function for device-specific DTB files
do_deploy() {
    install -d ${DEPLOYDIR}/devicetree/
}

addtask deploy before do_build after do_install
