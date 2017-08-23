#!../../bin/windows-x64/HFMAGPSU-IOC-03

## You may have to change HFMAGPSU-IOC-01 to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/HFMAGPSU-IOC-03.dbd"
HFMAGPSU_IOC_003_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocHFMAGPSU-IOC-01/st-common.cmd