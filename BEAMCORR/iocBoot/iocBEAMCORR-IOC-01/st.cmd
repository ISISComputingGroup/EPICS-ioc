#!../../bin/windows-x64/BEAMCORR

#- SPDX-FileCopyrightText: 2003 Argonne National Laboratory
#-
#- SPDX-License-Identifier: EPICS

#- You may have to change BEAMCORR to something else
#- everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths
epicsEnvSet "IOCNAME" "BEAMCORR_01"

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/BEAMCORR-IOC-01.dbd"
BEAMCORR_IOC_01_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocBEAMCORR-IOC-01/st-common.cmd

