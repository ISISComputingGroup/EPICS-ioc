#!../../bin/linux-x86_64/RKNPS-IOC-02

## You may have to change RKNPS-IOC-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "IOCNAME" "RKNPS_02"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/RKNPS-IOC-02.dbd"
RKNPS_IOC_02_registerRecordDeviceDriver pdbbase

## Load common st.cmd
< iocBoot/iocRKNPS-IOC-01/st-common.cmd
