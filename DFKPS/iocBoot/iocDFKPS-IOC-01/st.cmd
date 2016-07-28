#!../../bin/linux-x86_64/DFKPS-IOC-01

## You may have to change DFKPS-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "IOCNAME" "DFKPS_01"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/DFKPS-IOC-01.dbd"
DFKPS_IOC_01_registerRecordDeviceDriver pdbbase

## Load common st.cmd
< iocBoot/iocDFKPS-IOC-01/st-common.cmd
