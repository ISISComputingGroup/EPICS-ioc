#!../../bin/linux-x86_64/nanodac

## You may have to change nanodac to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/nanodac.dbd"
nanodac_registerRecordDeviceDriver pdbbase

####################################################
# TCP to Eurotherm

epicsEnvSet("IP_ADDR","192.168.200.177:502")

####################################################

####################################################################
# Set up modbus TCP support for Eurotherm

epicsEnvSet("NI","1")

< $(EUROTHERM)/st.cmd.main

< $(EUROTHERM)/st.cmd.loop1

< $(EUROTHERM)/st.cmd.loop2

< $(EUROTHERM)/st.cmd.user

< $(EUROTHERM)/st.cmd.alarm

####################################################################

## Load record instances
dbLoadRecords "db/nanodac.db"

cd ${TOP}/iocBoot/${IOC}
iocInit

