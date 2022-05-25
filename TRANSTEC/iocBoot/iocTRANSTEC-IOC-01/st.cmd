#!../../bin/windows-x64/TRANSTEC-IOC-01

## You may have to change TRANSTEC-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/TRANSTEC-IOC-01.dbd"
TRANSTEC_IOC_01_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocTRANSTEC-IOC-01/st-common.cmd
