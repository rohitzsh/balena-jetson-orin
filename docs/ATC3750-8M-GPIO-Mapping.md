# ATC3750-8M GPIO Mapping Documentation

## Overview
This document provides GPIO mapping and configuration details for the Nexcom ATC3750-8M with AGX Orin module.

## GPIO Configuration Summary

### Main GPIO Controller (@2200000)

#### Input Pins (37 pins)
| GPIO | Description | Pin Function |
|------|-------------|--------------|
| TEGRA234_MAIN_GPIO(B, 0) | GPIO_PB.00 | General Purpose Input |
| TEGRA234_MAIN_GPIO(Y, 3) | GPIO_PY.03 | General Purpose Input |
| TEGRA234_MAIN_GPIO(Y, 4) | GPIO_PY.04 | General Purpose Input |
| TEGRA234_MAIN_GPIO(Y, 7) | GPIO_PY.07 | General Purpose Input |
| TEGRA234_MAIN_GPIO(Z, 1) | GPIO_PZ.01 | General Purpose Input |
| TEGRA234_MAIN_GPIO(Z, 2) | GPIO_PZ.02 | General Purpose Input |
| TEGRA234_MAIN_GPIO(P, 6) | GPIO_PP.06 | General Purpose Input |
| TEGRA234_MAIN_GPIO(Q, 6) | GPIO_PQ.06 | General Purpose Input |
| TEGRA234_MAIN_GPIO(Q, 7) | GPIO_PQ.07 | General Purpose Input |
| TEGRA234_MAIN_GPIO(R, 1) | GPIO_PR.01 | General Purpose Input |
| TEGRA234_MAIN_GPIO(N, 4) | GPIO_PN.04 | General Purpose Input |
| TEGRA234_MAIN_GPIO(G, 0) | GPIO_PG.00 | General Purpose Input |
| TEGRA234_MAIN_GPIO(G, 1) | GPIO_PG.01 | General Purpose Input |
| TEGRA234_MAIN_GPIO(G, 2) | GPIO_PG.02 | General Purpose Input |
| TEGRA234_MAIN_GPIO(G, 4) | GPIO_PG.04 | General Purpose Input |
| TEGRA234_MAIN_GPIO(G, 7) | GPIO_PG.07 | General Purpose Input |
| TEGRA234_MAIN_GPIO(H, 0) | GPIO_PH.00 | General Purpose Input |
| TEGRA234_MAIN_GPIO(H, 5) | GPIO_PH.05 | General Purpose Input |
| TEGRA234_MAIN_GPIO(H, 7) | GPIO_PH.07 | General Purpose Input |
| TEGRA234_MAIN_GPIO(I, 0) | GPIO_PI.00 | General Purpose Input |
| TEGRA234_MAIN_GPIO(I, 1) | GPIO_PI.01 | General Purpose Input |
| TEGRA234_MAIN_GPIO(I, 2) | GPIO_PI.02 | General Purpose Input |
| TEGRA234_MAIN_GPIO(AC, 4) | GPIO_PAC.04 | General Purpose Input |
| TEGRA234_MAIN_GPIO(K, 0) | GPIO_PK.00 | General Purpose Input |
| TEGRA234_MAIN_GPIO(K, 1) | GPIO_PK.01 | General Purpose Input |
| TEGRA234_MAIN_GPIO(L, 2) | GPIO_PL.02 | General Purpose Input |
| TEGRA234_MAIN_GPIO(L, 3) | GPIO_PL.03 | General Purpose Input |
| TEGRA234_MAIN_GPIO(AG, 0) | GPIO_PAG.00 | General Purpose Input |
| TEGRA234_MAIN_GPIO(AG, 1) | GPIO_PAG.01 | General Purpose Input |
| TEGRA234_MAIN_GPIO(AG, 2) | GPIO_PAG.02 | General Purpose Input |
| TEGRA234_MAIN_GPIO(AG, 3) | GPIO_PAG.03 | General Purpose Input |
| TEGRA234_MAIN_GPIO(AG, 6) | GPIO_PAG.06 | General Purpose Input |
| TEGRA234_MAIN_GPIO(AG, 7) | GPIO_PAG.07 | General Purpose Input |
| TEGRA234_MAIN_GPIO(AF, 2) | GPIO_PAF.02 | General Purpose Input |
| TEGRA234_MAIN_GPIO(AF, 3) | GPIO_PAF.03 | General Purpose Input |

#### Output Low Pins (9 pins)
| GPIO | Description | Pin Function |
|------|-------------|--------------|
| TEGRA234_MAIN_GPIO(X, 0) | GPIO_PX.00 | Output Low |
| TEGRA234_MAIN_GPIO(X, 1) | GPIO_PX.01 | Output Low |
| TEGRA234_MAIN_GPIO(N, 3) | GPIO_PN.03 | Output Low |
| TEGRA234_MAIN_GPIO(H, 1) | GPIO_PH.01 | Output Low |
| TEGRA234_MAIN_GPIO(H, 3) | GPIO_PH.03 | Output Low |
| TEGRA234_MAIN_GPIO(H, 6) | GPIO_PH.06 | Output Low |
| TEGRA234_MAIN_GPIO(I, 5) | GPIO_PI.05 | Output Low |
| TEGRA234_MAIN_GPIO(K, 6) | GPIO_PK.06 | Output Low |
| TEGRA234_MAIN_GPIO(A, 1) | GPIO_PA.01 | Output Low |

#### Output High Pins (22 pins)
| GPIO | Description | Pin Function |
|------|-------------|--------------|
| TEGRA234_MAIN_GPIO(AC, 0) | GPIO_PAC.00 | Output High |
| TEGRA234_MAIN_GPIO(AC, 1) | GPIO_PAC.01 | Output High |
| TEGRA234_MAIN_GPIO(AC, 2) | GPIO_PAC.02 | Output High |
| TEGRA234_MAIN_GPIO(AC, 3) | GPIO_PAC.03 | Output High |
| TEGRA234_MAIN_GPIO(AC, 5) | GPIO_PAC.05 | Output High |
| TEGRA234_MAIN_GPIO(AC, 7) | GPIO_PAC.07 | Output High |
| TEGRA234_MAIN_GPIO(N, 2) | GPIO_PN.02 | Output High |
| TEGRA234_MAIN_GPIO(H, 4) | GPIO_PH.04 | Output High |
| TEGRA234_MAIN_GPIO(Q, 4) | GPIO_PQ.04 | Output High |
| TEGRA234_MAIN_GPIO(P, 4) | GPIO_PP.04 | Output High |
| TEGRA234_MAIN_GPIO(A, 2) | GPIO_PA.02 | Output High |
| TEGRA234_MAIN_GPIO(Y, 0) | GPIO_PY.00 | Output High |
| TEGRA234_MAIN_GPIO(Y, 1) | GPIO_PY.01 | Output High |
| TEGRA234_MAIN_GPIO(Y, 2) | GPIO_PY.02 | Output High |
| TEGRA234_MAIN_GPIO(Z, 0) | GPIO_PZ.00 | Output High |
| TEGRA234_MAIN_GPIO(Q, 1) | GPIO_PQ.01 | Output High |
| TEGRA234_MAIN_GPIO(G, 3) | GPIO_PG.03 | Output High |
| TEGRA234_MAIN_GPIO(K, 5) | GPIO_PK.05 | Output High |
| TEGRA234_MAIN_GPIO(K, 7) | GPIO_PK.07 | Output High |
| TEGRA234_MAIN_GPIO(R, 4) | GPIO_PR.04 | Output High |
| TEGRA234_MAIN_GPIO(A, 0) | GPIO_PA.00 | Output High |
| TEGRA234_MAIN_GPIO(A, 3) | GPIO_PA.03 | Output High |

### AON GPIO Controller (@c2f0000)

#### AON Input Pins (6 pins)
| GPIO | Description | Pin Function |
|------|-------------|--------------|
| TEGRA234_AON_GPIO(EE, 6) | GPIO_PEE.06 | AON Input |
| TEGRA234_AON_GPIO(EE, 2) | GPIO_PEE.02 | AON Input |
| TEGRA234_AON_GPIO(EE, 4) | GPIO_PEE.04 | AON Input |
| TEGRA234_AON_GPIO(CC, 0) | GPIO_PCC.00 | AON Input |
| TEGRA234_AON_GPIO(CC, 1) | GPIO_PCC.01 | AON Input |
| TEGRA234_AON_GPIO(BB, 1) | GPIO_PBB.01 | AON Input |

#### AON Output Low Pins (2 pins)
| GPIO | Description | Pin Function |
|------|-------------|--------------|
| TEGRA234_AON_GPIO(CC, 2) | GPIO_PCC.02 | AON Output Low |
| TEGRA234_AON_GPIO(CC, 3) | GPIO_PCC.03 | AON Output Low |

#### AON Output High Pins (2 pins)
| GPIO | Description | Pin Function |
|------|-------------|--------------|
| TEGRA234_AON_GPIO(BB, 3) | GPIO_PBB.03 | AON Output High |
| TEGRA234_AON_GPIO(EE, 5) | GPIO_PEE.05 | AON Output High |

### FSI GPIO Controller (@9250000)
Currently no GPIO pins configured for FSI controller.

## Hardware-Specific Features

### Serial Interfaces
The ATC3750-8M supports multiple serial communication protocols:
- **RS232**: Standard serial communication
- **RS422**: Differential serial communication
- **RS485**: Multi-point serial communication

**Note**: Specific pinmux configurations for serial interfaces need to be verified in the pinmux device tree file.

### Network Interfaces  
The ATC3750-8M includes network capabilities, but specific GPIO mapping for network interfaces requires further investigation in the pinmux configuration.

## Validation Script
A validation script is available at `scripts/validate_atc3750_gpio.sh` to check GPIO configuration integrity and provide summary information.

## Hardware Testing Requirements

### Basic GPIO Testing
1. **Input Pin Testing**: Verify all input pins can properly read logic levels
2. **Output Pin Testing**: Confirm all output pins can drive correct logic levels
3. **Pull-up/Pull-down Testing**: Validate internal pull resistor configurations

### Serial Interface Testing
1. **RS232 Testing**: Verify UART functionality on RS232 pins
2. **RS422 Testing**: Test differential signaling capability
3. **RS485 Testing**: Validate multi-point communication support

### Network Interface Testing
1. **Ethernet Testing**: Confirm network connectivity
2. **PHY Configuration**: Verify network PHY settings
3. **Link Status**: Test network link detection

## Known Issues and Limitations

1. **Serial Interface Mapping**: Explicit RS232/422/485 pin assignments not clearly defined in current configuration
2. **Network GPIO Mapping**: Ethernet-specific GPIO configurations need clarification
3. **Hardware Validation**: All configurations require testing on actual ATC3750-8M hardware

## Next Steps

1. Test GPIO configurations on actual hardware
2. Map serial interface pins to specific GPIO configurations  
3. Validate network interface GPIO assignments
4. Create hardware-specific test procedures
5. Update documentation based on hardware test results

---

*Generated as part of Task 2.2: GPIO and Pinmux Validation*  
*For technical support, refer to Nexcom ATC3750-8M hardware documentation*