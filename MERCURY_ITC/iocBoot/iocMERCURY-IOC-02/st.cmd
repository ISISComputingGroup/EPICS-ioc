#!../../bin/windows-x64/MERCURY-IOC-02
## You may have to change MERCURY-IOC-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

epicsEnvSet(IOC_NUM,2)
## Register all support components
dbLoadDatabase "dbd/MERCURY-IOC-02.dbd"
MERCURY_IOC_02_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/iocMERCURY-IOC-01

< st-common.cmd
