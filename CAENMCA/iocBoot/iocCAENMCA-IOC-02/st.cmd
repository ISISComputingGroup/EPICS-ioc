#!../../bin/windows-x64/CAENMCA-IOC-02

## You may have to change CAENMCA-IOC-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

## Register all support components
cd "${TOP}"
dbLoadDatabase "dbd/CAENMCA-IOC-02.dbd"
CAENMCA_IOC_02_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< iocBoot/iocCAENMCA-IOC-01/st-common.cmd
