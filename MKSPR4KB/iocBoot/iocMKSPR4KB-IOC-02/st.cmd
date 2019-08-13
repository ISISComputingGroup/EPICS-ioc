#!../../bin/windows-x64/MKSPR4KB-IOC-02

## You may have to change MKSPR4KB to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/MKSPR4KB-IOC-02.dbd"
MKSPR4KB_IOC_02_registerRecordDeviceDriver pdbbase

< $(TOP)/iocboot/iocMKSPR4KB-IOC-01/st-common.cmd
