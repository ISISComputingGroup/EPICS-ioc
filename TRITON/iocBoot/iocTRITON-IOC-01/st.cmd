#!../../bin/windows-x64/TRITON-IOC-01

## You may have to change TRITON-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

## Register all support components
dbLoadDatabase("../../dbd/TRITON-IOC-01.dbd",0,0)
TRITON_IOC_01_registerRecordDeviceDriver(pdbbase) 

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocTRITON-IOC-01/st-common.cmd
