#!../../bin/windows-x64/LVTEST-IOC-01

## You may have to change LVTEST-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

## Register all support components
dbLoadDatabase "$(TOP)/dbd/LVTEST-IOC-01.dbd"
LVTEST_IOC_01_registerRecordDeviceDriver pdbbase

## main args are:  portName, configSection, configFile, host, options (see lvDCOMConfigure() documentation in lvDCOMDriver.cpp)
##
## portName ("lvfp" below) refers to the asyn driver port name - it is the extrenal name used in epics DB files to refer to the driver instance
## configSection ("frontpanel" below) refers to the section of configFile ("lvinput.xml" below) where settings are read from
##    
## there are additional optional args to specify a DCOM ProgID for a compiled LabVIEW application 
## and a different username + password for remote host if that is required 
##
## the "options" argument is a combination of the following flags (as per the #lvDCOMOptions enum in lvDCOMInterface.h)
##    viWarnIfIdle=1, viStartIfIdle=2, viStopOnExitIfStarted=4, viAlwaysStopOnExit=8

lvDCOMConfigure("lvfp", "frontpanel", "$(TOP)/data/lvtest.xml", "", 6)
