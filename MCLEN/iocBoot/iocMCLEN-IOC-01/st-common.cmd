
< $(IOCSTARTUP)/init.cmd

< $(IOCSTARTUP)/dbload.cmd

# specify additional directories in which to to search for included request files
set_requestfile_path("${MOTOR}/motorApp/Db", "")
## as we are common, we need to explicity define the 01 area for when we are run by 02, 03 etc 
set_requestfile_path("${TOP}/iocBoot/iocMCLEN-IOC-01", "")

iocshCmdLoop("< st-ctrl.cmd", "CNUM=\$(I)", "I", 1, 24)

epicsEnvSet(MN,1)
< st-ifmotor

epicsEnvSet(MN,2)
< st-ifmotor

epicsEnvSet(MN,3)
< st-ifmotor

epicsEnvSet(MN,4)
< st-ifmotor

epicsEnvSet(MN,5)
< st-ifmotor

epicsEnvSet(MN,6)
< st-ifmotor

epicsEnvSet(MN,7)
< st-ifmotor

epicsEnvSet(MN,8)
< st-ifmotor

epicsEnvSet("MCLENCONFIG","$(ICPCONFIGROOT)/mclennan")

# configure axes
< axes.cmd

# motion set points
< motionsetpoints.cmd
< sampleChanger.cmd

## motor util package
dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

iocInit()

## motor util package
#var motorUtil_debug 1
motorUtilInit("$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
