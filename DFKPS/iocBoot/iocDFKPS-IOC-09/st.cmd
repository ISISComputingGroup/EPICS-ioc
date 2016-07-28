#!../../bin/linux-x86_64/DFKPS-IOC-09

## You may have to change DFKPS-IOC-09 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "IOCNAME" "DFKPS_09"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/DFKPS-IOC-09.dbd"
DFKPS_IOC_09_registerRecordDeviceDriver pdbbase

## Load common st.cmd
< iocBoot/iocDFKPS-IOC-01/st-common.cmd