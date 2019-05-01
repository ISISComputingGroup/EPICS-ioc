## Setup configured on an instrument
## Some files may not exist so will cause an error
## If using ensure the needed libraries and dbd files are included.

epicsEnvSet("IOC_CONFIG_DIR","$(ICPCONFIGROOT)/$(IOCNAME)")

## configure jaws
< $(IOC_CONFIG_DIR)/jaws.cmd

## configure axes
< $(IOC_CONFIG_DIR)/axes.cmd

## motion set points
< $(IOC_CONFIG_DIR)/motionsetpoints.cmd

## sample changer
< $(IOC_CONFIG_DIR)/sampleChanger.cmd

## motor extensions
$(IFNOTTESTDEVSIM) < $(IOC_CONFIG_DIR)/motorExtensions.cmd
$(IFTESTDEVSIM) < $(MOTOREXT)/settings/motorExtensions.cmd
