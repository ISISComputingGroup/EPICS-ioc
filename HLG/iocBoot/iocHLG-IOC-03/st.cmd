#!../../bin/windows-x64/HLG-IOC-03

## You may have to change HLG-IOC-03 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/HLG-IOC-03.dbd"
HLG_IOC_03_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocHLG-IOC-01/st-common.cmd
