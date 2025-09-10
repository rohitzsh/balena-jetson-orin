# NOTE: nvpower patches from tegra-demo-distro are incompatible with BalenaOS
# BalenaOS intentionally removes nvpmodel symlink creation functions that 
# the tegra-demo-distro patches try to modify. This functionality is not
# critical for basic ATC3750 operation, so we skip these patches.
#
# If nvpower functionality is needed later, custom patches will need to be
# created that work with the BalenaOS baseline after symlink removal.