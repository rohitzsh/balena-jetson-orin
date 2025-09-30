#  balena-jetson-orin repository

## Linux for Tegra (L4T) Support

All Jetson Orin boards in this repository tagged v5.3.23 and newer are using L4T 36.3 - Jetpack 6.

For devices which don't have production releases at versions greater than v5.3.23 in balena-cloud yet,
draft releases can be accessed using balena CLI.

IMPORTANT: Draft releases are meant for testing purposes only and should not be used in production environments

To view the available draft releases for a device-type:

`balena os versions <device_slug> --include-draft`

For example, to check the available production and draft releases for the Jetson Orin Nano 8GB (SD) Devkit NVME device-type, use the following command:

`balena os versions jetson-orin-nano-devkit-nvme --include-draft`

All device type slugs are available in the coffee files present in this repository.

To update a device to a draft release:

`balena device os-update <device_uuid> --include-draft`

The last L4T 35.5.0 - Jetpack 5-based production releases are:
* v5.3.21+rev3
* v5.3.21+rev2
* v5.3.21+rev1
* v5.3.21

balenaOS production images for Jetson devices at versions greater than v6.0 are based on Jetpack 6.

## Nexcom ATC3750-8M Support

The Nexcom ATC3750-8M industrial computer is supported with both 32GB and 64GB AGX Orin variants:

* **Device Types**: 
  - `nexcom-atc3750-8m-agx-orin-32gb` - ATC3750-8M with 32GB AGX Orin module
  - `nexcom-atc3750-8m-agx-orin-64gb` - ATC3750-8M with 64GB AGX Orin module

* **Hardware Features**:
  - GPIO validation and mapping completed (68 pins configured)
  - Serial interfaces: RS232, RS422, RS485 (requires hardware testing)
  - Network interfaces: Ethernet with PHY support
  - Storage: eMMC and NVMe support

* **Current Status**: 
  - Device type definitions: ✅ Complete
  - Machine configurations: ✅ Complete  
  - Device tree integration: ✅ Complete
  - GPIO validation: ✅ Complete
  - Bootloader integration: ✅ Complete

For detailed GPIO mapping and hardware specifications, see `docs/ATC3750-8M-GPIO-Mapping.md`.

## Clone/Initialize the repository

There are two ways of initializing this repository:
* Clone this repository with "git clone --recursive".

or

* Run "git clone" and then "git submodule update --init --recursive". This will bring in all the needed dependencies.

## Build information

balenaOS currently only builds with cgroups v1. If your distribution defaults
to using cgroups v2, please boot with the following kernel command line
argument:
`systemd.unified_cgroup_hierarchy=0`

### Containerized build

* If you have a working docker installation, you can build in a containerized
  environment as follows:
  `./balena-yocto-scripts/build/balena-build.sh -d <device type> -s <shared directory>`

  Where:
    * Device type is one of the supported devices with a valid `<device type name>.coffee` description file.
    * Shared directory is the absolute path to the build folder

  **ATC3750-8M Examples**:
  ```bash
  # Build 32GB variant
  ./balena-yocto-scripts/build/balena-build.sh -d nexcom-atc3750-8m-agx-orin-32gb -s /path/to/shared/build

  # Build 64GB variant  
  ./balena-yocto-scripts/build/balena-build.sh -d nexcom-atc3750-8m-agx-orin-64gb -s /path/to/shared/build
  ```

### Native build

To build all supported device types natively, please make sure your Linux
distribution is [supported](https://docs.yoctoproject.org/singleindex.html#supported-linux-distributions) by Yocto Project.

Additional host tools need to be installed for native builds to work.

* Run the barys build script:
  `./balena-yocto-scripts/build/barys`

* You can also run barys with the -h switch to inspect the available options

  **ATC3750-8M Examples**:
  ```bash
  # Build 32GB variant
  ./balena-yocto-scripts/build/barys -m nexcom-atc3750-8m-agx-orin-32gb

  # Build 64GB variant
  ./balena-yocto-scripts/build/barys -m nexcom-atc3750-8m-agx-orin-64gb

  # Dry-run to setup build environment
  ./balena-yocto-scripts/build/barys --remove-build --dry-run -m nexcom-atc3750-8m-agx-orin-64gb
  ```

### Custom build using this repository

* Run the barys build script in dry run mode to setup an empty `build` directory
    `./balena-yocto-scripts/build/barys --remove-build --dry-run`

* Edit the `local.conf` in the `build/conf` directory

* Prepare build's shell environment
    `source layers/poky/oe-init-build-env`

* Run bitbake (see message outputted when you sourced above for examples)

### Build flags

* Consult layers/meta-balena/README.md for info on various build flags (setting
up serial console support for example) and build prerequisites. Build flags can
be set by using the build scripts (barys or balena-build) or by manually
modifying `local.conf`.

## Contributing

### Issues

For issues we use an aggregated github repository available [here](https://github.com/balena-os/balenaos/issues). When you create issue make sure you select the right labels.

### Pull requests

To contribute send github pull requests targeting this repository.

Please refer to: [Yocto Contribution Guidelines](https://wiki.yoctoproject.org/wiki/Contribution_Guidelines#General_Information) and try to use the commit log format as stated there. Example:
```
<component>: Short description

I'm going to explain here what my commit does in a way that history
would be useful.

Changelog-entry: User facing description of the issue
Signed-off-by: Joe Developer <joe.developer@example.com>
```

The header of each commit must not exceed 72 characters in length and must be in 1 line only.

The header and the subject of each commit must be separated by an empty line.

The subject of each commit must not exceed 72 characters per line and can be wrapped to several lines.

The subject and the footer of each commit must be separated by an empty line.

Every pull request must contain at least one commit annotated with the `Changelog-entry` footer. The messages contained in these footers will be used to automatically fill the changelog on every new version.

Also, every update to `meta-balena` should be separated into its own commit, if the body of that commit contains the following line `Updated meta-balena from X to Y` the generated changelog will include a button to show all the updates in `meta-balena` from the version after `X` to `Y`.

An example of a valid commit updating `meta-balena` is:

```
layers/meta-balena: Update to v2.24.0

Update meta-balena from 2.19.0 to 2.24.0

Changelog-entry: Update the meta-balena submodule from v2.19.0 to v2.24.0
```

Make sure you mention the issue addressed by a PR. See:
* https://help.github.com/articles/autolinked-references-and-urls/#issues-and-pull-requests
* https://help.github.com/articles/closing-issues-via-commit-messages/#closing-an-issue-in-a-different-repository
