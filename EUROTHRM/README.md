# Eurotherm IOC
Eurotherm is a temperature controller. They come in a number of different configurations, namely crates with varying numbers of sensors. 

## Eurotherm Useful Recources
### Eurotherm2k support directory
- [Eurotherm2k Support Directory](https://github.com/ISISComputingGroup/EPICS-eurotherm2k/) 

### IOC System Tests
- [Eurotherm System Tests](https://github.dev/ISISComputingGroup/EPICS-IOC_Test_Framework/blob/7026_eurotherm_7_plus_channel/tests/eurotherm.py)

To run eurotherm system tests, open an EPICS terminal and run the following command from the EPICS-IOC_Test_Framework directory:
`python run_tests.py -t eurotherm`

This will run system tests for channel 1 by default. 
To test other channels, modify `EPICS-IOC_Test_Framework/tests/eurotherm.py` to change the address variables. Below is an example of the changes needed to test channel 10:


```python
# Internal Address of device (must be 2 characters)
ADDRESS = "A010" # Change this to the channel you want to test
# Numerical address of the device
ADDR_1 = 1 # Leave this value as 1 when changing the ADDRESS value above - hard coded in LEWIS emulator
DEVICE = "EUROTHRM_01"
PREFIX = "{}:{}".format(DEVICE, ADDRESS)

# PV names
RBV_PV = "RBV"

EMULATOR_DEVICE = "eurotherm"

IOCS = [
    {
        "name": DEVICE,
        "directory": get_default_ioc_dir("EUROTHRM"),
        "ioc_launcher_class": ProcServLauncher,
        "macros": {
            "ADDR": ADDRESS,
            "ADDR_1": "",
            "ADDR_2": "",
            "ADDR_3": "",
            "ADDR_4": "",
            "ADDR_5": "",
            "ADDR_6": "",
            "ADDR_7": "",
            "ADDR_8": "",
            "ADDR_9": "",
            "ADDR_10": ADDR_1 # Move ADDR_1 to the address you want to test
        },
        "emulator": EMULATOR_DEVICE,
    },
]
```

### Wiki Pages
- [Eurotherm Wiki Page](https://github.com/ISISComputingGroup/IBEX/wiki/Eurotherms)

## Useful Commands

Single Eurotherm IOC:
- `%MYPVPREFIX%EUROTHRM_01:<ADDRESS>:<PV>`

Read current temperature for address 4:
- `caget caget %MYPVPREFIX%EUROTHRM_01:A04:CURRENT_TEMP`