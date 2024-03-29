
##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(RKNMNTR)/db/RIKEN_TEMP_CALC.db","PVPREFIX=$(MYPVPREFIX),HOST=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,DISABLE=$(DISABLE=0)")
dbLoadRecords("$(RKNMNTR)/db/rknmntr.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,DISABLE=$(DISABLE=0)")

$(IFRECSIM) dbLoadRecords("$(RKNMNTR)/db/test_PSU_PVs.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX),DISABLE=$(DISABLE=0)")
$(IFRECSIM) dbLoadRecords("$(RKNMNTR)/db/test_block_curr_PVs.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX),DISABLE=$(DISABLE=0)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=eii24694"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
