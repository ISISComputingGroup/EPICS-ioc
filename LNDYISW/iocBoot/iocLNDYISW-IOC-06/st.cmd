#!../../bin/windows-x64/LNDYISW-IOC-06

## You may have to change LNDYISW-IOC-06 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/LNDYISW-IOC-06.dbd"
LNDYISW_IOC_06_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocLNDYISW-IOC-01/st-common.cmd
