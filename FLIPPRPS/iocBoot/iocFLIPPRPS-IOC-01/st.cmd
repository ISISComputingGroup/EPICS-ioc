#!../../bin/windows-x64/FLIPPRPS-IOC-01

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/FLIPPRPS-IOC-01.dbd"
FLIPPRPS_IOC_01_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocFLIPPRPS-IOC-01/st-common.cmd
