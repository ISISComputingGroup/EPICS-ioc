#!../../bin/windows-x64/CRYOSMS-IOC-02

## You may have to change CRYOSMS to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/CRYOSMS-IOC-02.dbd"
CRYOSMS_IOC_02_registerRecordDeviceDriver pdbbase

< $(TOP)/iocboot/iocCRYOSMS-IOC-01/st-common.cmd
