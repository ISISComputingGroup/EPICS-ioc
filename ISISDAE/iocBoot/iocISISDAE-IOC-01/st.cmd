#!../../bin/windows-x64-debug/ISISDAE-IOC-01

## You may have to change ISISDAE-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 4096)

< envPaths
epicsEnvSet "WIRING_DIR" "$(ICPCONFIGROOT)/tables"
epicsEnvSet "WIRING_PATTERN" ".*wiring.*"
epicsEnvSet "DETECTOR_DIR" "$(ICPCONFIGROOT)/tables"
epicsEnvSet "DETECTOR_PATTERN" ".*det.*"
epicsEnvSet "SPECTRA_DIR" "$(ICPCONFIGROOT)/tables"
epicsEnvSet "SPECTRA_PATTERN" ".*spec.*"
epicsEnvSet "PERIOD_DIR" "$(ICPCONFIGROOT)/tables"
epicsEnvSet "PERIOD_PATTERN" ".*period.*"
epicsEnvSet "TCB_DIR" "$(ICPCONFIGROOT)/tcb"
epicsEnvSet "TCB_PATTERN" ".*tcb.*"

## this needs to be large enouth for DAE spectra and
## also for areaDetector (see liveview.cmd) 
epicsEnvSet "EPICS_CA_MAX_ARRAY_BYTES" 20000000

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/ISISDAE-IOC-01.dbd"
ISISDAE_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

# The search path for database files
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db")

asynSetMinTimerPeriod(0.001)

## used for restarting and checking EPICS block archiver via web URL
webgetConfigure("arch1")
webgetConfigure("arch2")

## uncomment to disable uamps too large check
#epicsEnvSet("NOCHECKFUAMP","1")

## local dae, no dcom/labview
## define max number of live detectos and max (x,y) size of each
## we no longer support DAEDCOM macro, all access is via DCOM
## pass 1 as second arg to signify DCOM to either local or remote dae
## pass 2 as second arg to signify SECI mode
## args: port,options,host,user,password,num_liveview
##   num_liveview should match number of  liveview.cmd loaded later
isisdaeConfigure("icp", 1, "$(DAEHOST=)", "$(DAEUSER=)", "$(DAEPW=)", 5)

## Load the FileLists
FileListConfigure("WLIST", "$(WIRING_DIR)", "$(WIRING_PATTERN)", 1)
FileListConfigure("DLIST", "$(DETECTOR_DIR)", "$(DETECTOR_PATTERN)", 1)
FileListConfigure("SLIST", "$(SPECTRA_DIR)", "$(SPECTRA_PATTERN)", 1)
FileListConfigure("PLIST", "$(PERIOD_DIR)", "$(PERIOD_PATTERN)", 1)
FileListConfigure("TLIST", "$(TCB_DIR)", "$(TCB_PATTERN)", 1)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

epicsEnvSet("Q","DAE:")
## Set PARALLEL=# to enable parallel DAE3
$(PARALLEL=) epicsEnvSet("IFPARALLEL","#")
$(IFPARALLEL=) epicsEnvSet("VETO_DELAY","1")
$(IFPARALLEL=) epicsEnvSet("OTHER_DAE","TE:NDW847:DAE:")
$(IFPARALLEL=) epicsEnvSet("VETO_1","$(MYPVPREFIX)TEKAFG3XXX_01:OUTPUT1:STATUS:SP")
$(IFPARALLEL=) epicsEnvSet("VETO_2","$(MYPVPREFIX)TEKAFG3XXX_01:OUTPUT2:STATUS:SP")
$(IFPARALLEL=) epicsEnvSet("ENDRUN_DAE3","$(MYPVPREFIX)DAE:ENDRUN_DAE3")
$(IFPARALLEL=) epicsEnvSet("BEGINRUN_DAE3","$(MYPVPREFIX)DAE:BEGINRUN_DAE3")

## Load our record instances
$(IFPARALLEL=) dbLoadRecords("$(ISISDAE)/db/dae3_parallel.db","P=$(MYPVPREFIX), Q=$(Q), OTHER_DAE=$(OTHER_DAE=), VETO_1=$(VETO_1=), VETO_2=$(VETO_2=), VETO_DELAY=$(VETO_DELAY=)")

dbLoadRecords("$(ISISDAE)/db/isisdae.db","S=$(MYPVPREFIX), P=$(MYPVPREFIX), Q=$(Q), WIRINGLIST=WLIST, DETECTORLIST=DLIST, SPECTRALIST=SLIST, PERIODLIST=PLIST, TCBLIST=TLIST, BEGINRUNA=$(BEGINRUN_DAE3=$(MYPVPREFIX)$(Q)_BEGINRUN1), ENDRUNA=$(ENDRUN_DAE3=$(MYPVPREFIX)$(Q)_ENDRUN1),POST_BEGIN_1=$(POST_BEGIN_1=),POST_BEGIN_2=$(POST_BEGIN_2=),POST_BEGIN_3=$(POST_BEGIN_3=),POST_BEGIN_4=$(POST_BEGIN_4=),POST_END_1=$(POST_END_1=),POST_END_2=$(POST_END_2=),POST_END_3=$(POST_END_3=),POST_END_4=$(POST_END_4=),POST_ABORT_1=$(POST_ABORT_1=),POST_ABORT_2=$(POST_ABORT_2=),POST_ABORT_3=$(POST_ABORT_3=),POST_ABORT_4=$(POST_ABORT_4=),POST_PAUSE_1=$(POST_PAUSE_1=),POST_PAUSE_2=$(POST_PAUSE_2=),POST_PAUSE_3=$(POST_PAUSE_3=),POST_PAUSE_4=$(POST_PAUSE_4=),POST_RESUME_1=$(POST_RESUME_1=),POST_RESUME_2=$(POST_RESUME_2=),POST_RESUME_3=$(POST_RESUME_3=),POST_RESUME_4=$(POST_RESUME_4=)")
dbLoadRecords("$(ISISDAE)/db/dae_diag.db","P=$(MYPVPREFIX),Q=DAE:")
dbLoadRecords("$(ISISDAE)/db/veto.db","P=$(MYPVPREFIX),Q=DAE:")
dbLoadRecords("$(ISISDAE)/db/inst_string_parameters.db","P=$(MYPVPREFIX)")
dbLoadRecords("$(ISISDAE)/db/inst_alias_string_parameters.db","P=$(MYPVPREFIX)")
dbLoadRecords("$(ISISDAE)/db/inst_real_parameters.db","P=$(MYPVPREFIX)")

cd ${TOP}/iocBoot/${IOC}

#ffmpegServerConfigure(8081)

## load same number of instances as specified to isisdaeConfigure() above
iocshLoad "liveview.cmd", "LVDET=1,LVADDR=0"
iocshLoad "liveview.cmd", "LVDET=2,LVADDR=1"
iocshLoad "liveview.cmd", "LVDET=3,LVADDR=2"
iocshLoad "liveview.cmd", "LVDET=4,LVADDR=3"
iocshLoad "liveview.cmd", "LVDET=5,LVADDR=4"

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

## 0=none,0x1=err,0x2=IO_device,0x4=IO_filter,0x8=IO_driver,0x10=flow,0x20=warning
#asynSetTraceMask("icp", -1, 0x11)

iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

# Save motor positions every 5 seconds
create_monitor_set("$(IOCNAME)_positions.req", 5, "P=$(MYPVPREFIX)$(Q)")

# Save motor settings every 30 seconds
create_monitor_set("$(IOCNAME)_settings.req", 30, "P=$(MYPVPREFIX)$(Q)")
