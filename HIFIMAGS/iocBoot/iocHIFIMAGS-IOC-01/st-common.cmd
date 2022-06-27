epicsEnvSet "STREAM_PROTOCOL_PATH" "$(HIFIMAGS)/data"
epicsEnvSet "DEVICE" "L0"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(TOP)/db/hifimags.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),GM_IOC=$(GM_IOC=),RCOMP_IOC=$(RCOMP_IOC=),LCOMP_IOC=$(LCOMP_IOC=)")
dbLoadRecords("$(TOP)/db/hifimags_magnet.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),X_IOC=$(X_IOC=),Y_IOC=$(Y_IOC=),Z_IOC=$(Z_IOC=),M_IOC=$(SMS_IOC=)")
dbLoadRecords("$(TOP)/db/switching.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),MAG=$(MAG=Z),PSU_IOC=$(Z_IOC=)")
dbLoadRecords("$(TOP)/db/mainpsu.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),MAG=$(MAG=M),PSU_IOC=$(SMS_IOC=)")
dbLoadRecords("$(TOP)/db/hifimags_temp.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),STAGE1=$(TEMP_STAGE1=), SHIELD=$(TEMP_SHIELD=), SWITCH=$(TEMP_SWITCH=), STAGE2A=$(TEMP_STAGE2A=), STAGE2B=$(TEMP_STAGE2B=), INRABAS=$(TEMP_INRABAS=)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
seq hifimagsys, "P=$(MYPVPREFIX)$(IOCNAME):"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
