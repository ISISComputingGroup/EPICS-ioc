#!../../bin/windows-x64/LKSHTEMP-IOC-07

## You may have to change LKSHTEMP-IOC-07 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/LKSHTEMP-IOC-07.dbd"
LKSHTEMP_IOC_07_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocLKSHTEMP-IOC-01/st-common.cmd
