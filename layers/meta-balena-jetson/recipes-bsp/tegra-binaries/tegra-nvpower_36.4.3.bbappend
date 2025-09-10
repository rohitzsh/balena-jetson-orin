FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Apply Nexcom ATC3750 power management patches for both variants
SRC_URI:append:nexcom-atc3750-8m-agx-orin-32gb = " \
    file://0001-nvpower-add-nvpmodel-symlink-funciton.patch \
    file://0001-nvpower-add-nvpower-shell-script.patch \
    file://0002-nvpower-add-agx-orin-32-64g-symlink.patch \
"

SRC_URI:append:nexcom-atc3750-8m-agx-orin-64gb = " \
    file://0001-nvpower-add-nvpmodel-symlink-funciton.patch \
    file://0001-nvpower-add-nvpower-shell-script.patch \
    file://0002-nvpower-add-agx-orin-32-64g-symlink.patch \
"

SRC_URI:append:nexcom-atc3750-6c-agx-orin-32gb = " \
    file://0001-nvpower-add-nvpmodel-symlink-funciton.patch \
    file://0001-nvpower-add-nvpower-shell-script.patch \
    file://0002-nvpower-add-agx-orin-32-64g-symlink.patch \
"

SRC_URI:append:nexcom-atc3750-6c-agx-orin-64gb = " \
    file://0001-nvpower-add-nvpmodel-symlink-funciton.patch \
    file://0001-nvpower-add-nvpower-shell-script.patch \
    file://0002-nvpower-add-agx-orin-32-64g-symlink.patch \
"