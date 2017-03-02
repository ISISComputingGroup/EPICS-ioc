#!../../bin/linux-x86_64/nanodac

## You may have to change nanodac to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/nanodac.dbd"
NANODAC_registerRecordDeviceDriver pdbbase

####################################################
# TCP to Nanodac
< $(IOCSTARTUP)/init.cmd
$(IFNOTDEVSIM) epicsEnvSet("IP_ADDR","$(IP):502")

## For emulator use:
$(IFDEVSIM) freeIPPort("FREEPORT")  
$(IFDEVSIM) epicsEnvShow("FREEPORT") 
$(IFDEVSIM) epicsEnvSet("IP_ADDR","localhost:$(FREEPORT=0)")

####################################################

####################################################################
# Set up modbus TCP support for Nanodac

epicsEnvSet("NI","1")

< $(NANODAC)/st.cmd.main

< $(NANODAC)/st.cmd.loop1

< $(NANODAC)/st.cmd.loop2

< $(NANODAC)/st.cmd.user

< $(NANODAC)/st.cmd.alarm

####################################################################

## Load record instances
dbLoadRecords "db/nanodac.db"

cd ${TOP}/iocBoot/${IOC}
iocInit

