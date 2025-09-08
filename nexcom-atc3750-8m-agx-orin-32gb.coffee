deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

BOARD_PREPARE  = 'Put the Nexcom ATC3750-8M with AGX Orin 32GB in recovery mode'
FLASH_TOOL = 'Unzip BalenaOS image and use <a href="https://github.com/balena-os/jetson-flash">Jetson Flash</a> to provision the device.'
DONE_FLASHING  = 'After flashing is completed, please wait until the board is rebooted'
module.exports =
	version: 1
	slug: 'nexcom-atc3750-8m-agx-orin-32gb'
	name: 'Nexcom ATC3750-8M AGX Orin 32GB'
	arch: 'aarch64'
	state: 'released'

	instructions: [
		BOARD_PREPARE
		FLASH_TOOL
		DONE_FLASHING
	]

	gettingStartedLink:
		windows: 'https://docs.balena.io/nexcom-atc3750-8m-agx-orin-32gb/nodejs/getting-started/#adding-your-first-device'
		osx: 'https://docs.balena.io/nexcom-atc3750-8m-agx-orin-32gb/nodejs/getting-started/#adding-your-first-device'
		linux: 'https://docs.balena.io/nexcom-atc3750-8m-agx-orin-32gb/nodejs/getting-started/#adding-your-first-device'

	supportsBlink: false

	yocto:
		machine: 'nexcom-atc3750-8m-agx-orin-32gb'
		image: 'balena-image-flasher'
		fstype: 'balenaos-img'
		version: 'yocto-kirkstone'
		deployArtifact: 'balena-image-flasher-nexcom-atc3750-8m-agx-orin-32gb.balenaos-img'
		compressed: true

	options: [ networkOptions.group ]

	configuration:
		config:
			partition:
				primary: 1
			path: '/config.json'

	initialization: commonImg.initialization