#!../../bin/windows-x64/MERCURY_CRYO

## You may have to change MERCURY_CRYO to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/MERCURY_CRYO.dbd"
MERCURY_CRYO_registerRecordDeviceDriver pdbbase

lvDCOMConfigure("lvfp", "frontpanel", "$(MERCURY_CRYO)/data/lv_controls.xml", "$(LVDCOM_HOST=localhost)", 6, "", "", "")
dbLoadRecords("$(MERCURY_CRYO)/Db/controls.db","P=$(MYPVPREFIX)MERCURY_CRYO:"))

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocMERCURY_CRYO/st-common.cmd
