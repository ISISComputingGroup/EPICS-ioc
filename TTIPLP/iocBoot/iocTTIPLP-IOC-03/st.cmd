#!../../bin/windows-x64/TTIPLP-IOC-03

## You may have to change TTIPLP-IOC-03 to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/TTIPLP-IOC-03.dbd"
TTIPLP_IOC_03_registerRecordDeviceDriver pdbbase

< $(TOP)/iocboot/iocTTIPLP-IOC-01/st-common.cmd
