epicsEnvSet "DEVICE" "L0

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

lvDCOMConfigure("lvfp", "frontpanel", "${TOP}/data/lv_controls.xml", "$(LVDCOM_HOST=)", $(LVDCOM_OPTIONS=10), "$(LVDCOM_PROGID=)", "$(LVDCOM_USER=)", "$(LVDCOM_PASS=)")

#$(IFRECSIM) drvAsynSerialPortConfigure("lvfp", "$(PORT=NUL)", 0, 1, 0, 0)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("${TOP}/db/controls.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),AREA_HIGH_LIMIT=$(AREA_HIGH_LIMIT=247.0),AREA_LOW_LIMIT=$(AREA_LOW_LIMIT=36.0),PRESSURE_HIGH_LIMIT=$(PRESSURE_HIGH_LIMIT=75.0),PRESSURE_LOW_LIMIT=$(PRESSURE_LOW_LIMIT=-75.0),SPEED_HIGH_LIMIT=$(SPEED_HIGH_LIMIT=174.2),SPEED_LOW_LIMIT=$(SPEED_LOW_LIMIT=-174.2)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=ffv81422"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
