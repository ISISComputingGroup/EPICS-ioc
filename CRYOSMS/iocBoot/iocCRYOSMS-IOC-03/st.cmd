#!../../bin/windows-x64/CRYOSMS-IOC-03

## You may have to change CRYOSMS to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/CRYOSMS-IOC-03.dbd"
CRYOSMS_IOC_03_registerRecordDeviceDriver pdbbase

< $(TOP)/iocboot/iocCRYOSMS-IOC-01/st-common.cmd
