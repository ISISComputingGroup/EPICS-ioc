#!../../bin/windows-x64/OMIBTHX-IOC-01

## You may have to change OMIBTHX-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

## Register all support components
dbLoadDatabase("../../dbd/OMIBTHX-IOC-01.dbd",0,0)
OMIBTHX_IOC_01_registerRecordDeviceDriver(pdbbase) 

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocOMIBTHX-IOC-01/st-common.cmd
