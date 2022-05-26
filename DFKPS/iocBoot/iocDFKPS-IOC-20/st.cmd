#!../../bin/linux-x86_64/DFKPS-IOC-20

## You may have to change DFKPS-IOC-20 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "IOCNAME" "DFKPS_20"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/DFKPS-IOC-20.dbd"
DFKPS_IOC_20_registerRecordDeviceDriver pdbbase

## Load FileList
## A seperate instance must be created for each danfysik
epicsEnvSet "RAMP_DIR" "C:/Instrument/Settings"
epicsEnvSet "RAMP_PAT" ".*"
FileListConfigure("RAMPFILELIST20", $(RAMP_DIR), $(RAMP_PAT)) 

## Load common st.cmd
< iocBoot/iocDFKPS-IOC-01/st-common.cmd
