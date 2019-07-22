#!../../bin/windows-x64/WM323-IOC-01

## You may have to change WM323 to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/WM323-IOC-01.dbd"
WM323_IOC_01_registerRecordDeviceDriver pdbbase

< $(TOP)/iocboot/iocWM323-IOC-01/st-common.cmd
