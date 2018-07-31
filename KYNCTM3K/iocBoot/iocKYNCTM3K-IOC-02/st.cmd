#!../../bin/windows-x64/KYNCTM3K-IOC-02

## You may have to change KYNCTM3K-IOC-02 to something else
## everywhere it appears in this file

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/KYNCTM3K-IOC-02.dbd"
KYNCTM3K_IOC_02_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC common boot file
< ${TOP}/iocBoot/iocKYNCTM3K-IOC-01/st-common.cmd
