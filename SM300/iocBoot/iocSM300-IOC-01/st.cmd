#!../../bin/IBEX/SM300-IOC-01

## You may have to change SM300-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths


## Register all support components
dbLoadDatabase("${TOP}/dbd/SM300-IOC-01.dbd",0,0)
SM300_IOC_01_registerRecordDeviceDriver(pdbbase) 


cd ${TOP}/iocBoot/${IOC}

< st-common.cmd
