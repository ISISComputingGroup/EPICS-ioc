#!../../bin/windows-x64/SCHNDR-IOC-02

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/SCHNDR-IOC-02.dbd"
SCHNDR_IOC_02_registerRecordDeviceDriver pdbbase

cd iocBoot/iocSCHNDR-IOC-01

< st-common.cmd
