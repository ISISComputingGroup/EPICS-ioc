#!../../bin/windows-x64/CRYOSMS-IOC-04

## You may have to change CRYOSMS to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/CRYOSMS-IOC-04.dbd"
CRYOSMS_IOC_04_registerRecordDeviceDriver pdbbase

< $(TOP)/iocboot/iocCRYOSMS-IOC-01/st-common.cmd
