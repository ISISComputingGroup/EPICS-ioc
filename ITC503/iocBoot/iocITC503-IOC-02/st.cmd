#!../../bin/windows-x64/ITC503-IOC-02

## You may have to change ITC503 to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/ITC503-IOC-02.dbd"
ITC503_IOC_02_registerRecordDeviceDriver pdbbase

< $(TOP)/iocboot/iocITC503-IOC-01/st-common.cmd
