#!../../bin/win32-x86/DMA4500M-IOC-01

## You may have to change DMA4500M-IOC-01 to something else
## everywhere it appears in this file

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase("dbd/DMA4500M-IOC-01.dbd",0,0)
DMA4500M_IOC_01_registerRecordDeviceDriver(pdbbase) 

##ISIS## Run IOC common boot file
< ${TOP}/iocBoot/iocDMA4500M-IOC-01/st-common.cmd
