#!../../bin/win32-x86/CAENMCA-IOC-01

## You may have to change CAENMCA-IOC-01 to something else
## everywhere it appears in this file

errlogInit2(65536, 256)
< envPaths

## Register all support components
dbLoadDatabase("../../dbd/CAENMCA-IOC-01.dbd",0,0)
CAENMCA_IOC_01_registerRecordDeviceDriver(pdbbase) 

< st-common.cmd
