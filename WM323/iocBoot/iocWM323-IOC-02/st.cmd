#!../../bin/windows-x64/WM323-IOC-02

## You may have to change WM323 to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/WM323-IOC-02.dbd"
WM323_IOC_02_registerRecordDeviceDriver pdbbase

< $(TOP)/iocboot/iocWM323-IOC-01/st-common.cmd
