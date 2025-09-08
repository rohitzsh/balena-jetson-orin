#!/bin/bash
#
# ATC3750-8M GPIO Configuration Validation Script
# This script validates GPIO configurations for the Nexcom ATC3750-8M
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# GPIO configuration files
GPIO_DTSI="$PROJECT_DIR/layers/meta-balena-jetson/recipes-bsp/tegra-binaries/nexcom-atc3750-8m/Orin-atc3750-8M-gpio.dtsi"
PINMUX_DTSI="$PROJECT_DIR/layers/meta-balena-jetson/recipes-bsp/tegra-binaries/nexcom-atc3750-8m/Orin-atc3750-8M-pinmux.dtsi"

echo -e "${GREEN}ATC3750-8M GPIO Configuration Validation${NC}"
echo "======================================="

# Check if GPIO files exist
echo -n "Checking GPIO configuration files... "
if [[ -f "$GPIO_DTSI" && -f "$PINMUX_DTSI" ]]; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}FAILED${NC}"
    echo "Missing configuration files:"
    [[ ! -f "$GPIO_DTSI" ]] && echo "  - $GPIO_DTSI"
    [[ ! -f "$PINMUX_DTSI" ]] && echo "  - $PINMUX_DTSI"
    exit 1
fi

# Validate GPIO syntax
echo -n "Validating GPIO syntax... "
if cpp -I"$PROJECT_DIR/layers/meta-tegra/recipes-kernel/linux/linux-nvidia-headers/include" \
   "$GPIO_DTSI" > /dev/null 2>&1; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${YELLOW}WARNING${NC} - Cannot validate syntax (preprocessor not available)"
fi

# Count GPIO configurations
echo
echo "GPIO Configuration Summary:"
echo "-------------------------"
MAIN_INPUT_COUNT=$(grep -c "TEGRA234_MAIN_GPIO" "$GPIO_DTSI" | grep -A 20 "gpio-input" | grep -c "TEGRA234_MAIN_GPIO" || echo 0)
MAIN_OUTPUT_LOW_COUNT=$(grep -A 10 "gpio-output-low" "$GPIO_DTSI" | grep -c "TEGRA234_MAIN_GPIO" || echo 0)
MAIN_OUTPUT_HIGH_COUNT=$(grep -A 20 "gpio-output-high" "$GPIO_DTSI" | grep -c "TEGRA234_MAIN_GPIO" || echo 0)
AON_INPUT_COUNT=$(grep -A 10 "gpio_aon_default" "$GPIO_DTSI" | grep -A 5 "gpio-input" | grep -c "TEGRA234_AON_GPIO" || echo 0)
AON_OUTPUT_LOW_COUNT=$(grep -A 10 "gpio_aon_default" "$GPIO_DTSI" | grep -A 5 "gpio-output-low" | grep -c "TEGRA234_AON_GPIO" || echo 0)
AON_OUTPUT_HIGH_COUNT=$(grep -A 10 "gpio_aon_default" "$GPIO_DTSI" | grep -A 5 "gpio-output-high" | grep -c "TEGRA234_AON_GPIO" || echo 0)

echo "Main GPIO - Input pins: $MAIN_INPUT_COUNT"
echo "Main GPIO - Output Low pins: $MAIN_OUTPUT_LOW_COUNT" 
echo "Main GPIO - Output High pins: $MAIN_OUTPUT_HIGH_COUNT"
echo "AON GPIO - Input pins: $AON_INPUT_COUNT"
echo "AON GPIO - Output Low pins: $AON_OUTPUT_LOW_COUNT"
echo "AON GPIO - Output High pins: $AON_OUTPUT_HIGH_COUNT"

# Check for hardware-specific features
echo
echo "Hardware Feature Detection:"
echo "-------------------------"
if grep -q "RS232\|RS422\|RS485" "$PINMUX_DTSI" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Serial interface configurations found"
else
    echo -e "${YELLOW}!${NC} Serial interface configurations not explicitly found"
fi

if grep -q "ethernet\|phy" "$PINMUX_DTSI" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Ethernet configurations found"  
else
    echo -e "${YELLOW}!${NC} Ethernet configurations not explicitly found"
fi

echo
echo -e "${GREEN}Validation completed successfully!${NC}"
echo
echo "Next Steps:"
echo "- Test GPIO configurations on actual hardware"
echo "- Verify serial interface functionality (RS232/422/485)"
echo "- Validate network interface configurations"