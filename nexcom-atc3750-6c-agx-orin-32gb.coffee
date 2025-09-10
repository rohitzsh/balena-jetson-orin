deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

MACHINE_NAME = 'nexcom-atc3750-6c-agx-orin-32gb'
BOARD_PREPARE = 'Put the Nexcom ATC3750-6C board in recovery mode'
BOARD_SHUTDOWN = 'Remove power from the Nexcom ATC3750-6C board'
FLASH_TOOL = 'mkfs.fat -I'

module.exports =
	version: 1
	slug: 'nexcom-atc3750-6c-agx-orin-32gb'
	name: 'Nexcom ATC3750-6C AGX Orin 32GB'
	arch: 'aarch64'
	state: 'new'

	instructions: commonImg.instructions
	gettingStartedLink:
		windows: 'https://www.balena.io/docs/learn/getting-started/jetson-orin-agx-devkit/nodejs/'
		osx: 'https://www.balena.io/docs/learn/getting-started/jetson-orin-agx-devkit/nodejs/'
		linux: 'https://www.balena.io/docs/learn/getting-started/jetson-orin-agx-devkit/nodejs/'
	supportsBlink: false

	options: [ networkOptions.group ]

	yocto:
		machine: MACHINE_NAME
		image: 'balena-image-flasher'
		fstype: 'balenaos-img'
		version: 'yocto-kirkstone'
		deployArtifact: 'balena-image-flasher-nexcom-atc3750-6c-agx-orin-32gb.balenaos-img'
		compressed: true

	configuration:
		config:
			partition:
				primary: 12
			fstype: 'fat32'

	initialization: commonImg.initialization