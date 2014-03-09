## GALILCRATE and GCID are set prior to call

## GALILCRATE is the galil crate number - 01, 02, ...
## GCID is the controller ID within the software - 00, 01, ...

#Choose 1 out of the 2 dbLoadRecords statements below for your application

#dbLoadRecords("$(TOP)/db/galil_motor_withoutwrappers.db", "PP=$(MYPVPREFIXNC),CC=$(GCID),CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")
dbLoadRecords("$(TOP)/db/galil_motor_withwrappers.db", "PP=$(MYPVPREFIXNC),CC=$(GCID),CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")

#Load extra functionality, untop of motorRecord features for axis/motors (eg. runtime gear ratio changes between master & slaves)
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_ctrl_extras.db", "PP=$(MYPVPREFIXNC),CC=$(GCID),CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_motor_extras.db", "PP=$(MYPVPREFIXNC),CC=$(GCID),CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")

#Load digital IO databases
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_digital_ports.db", "PP=$(MYPVPREFIX),CC=$(GCID),CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")

#Load analog IO databases
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_analog_ports.db", "PP=$(MYPVPREFIX),CC=$(GCID),CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")

#Load user defined functions
#dbLoadRecords("$(TOP)/db/galil_userdef_records.db", "PP=$(MYPVPREFIXNC),CC=$(GCID),CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_userdef_records8.db", "PP=$(MYPVPREFIXNC),CC=$(GCID),CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")
