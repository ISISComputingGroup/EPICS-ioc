#!../../bin/windows-x64/MKSPR4KB-IOC-01

## You may have to change MKSPR4KB to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/MKSPR4KB-IOC-01.dbd"
MKSPR4KB_IOC_01_registerRecordDeviceDriver pdbbase

< $(TOP)/iocboot/iocMKSPR4KB-IOC-01/st-common.cmd
