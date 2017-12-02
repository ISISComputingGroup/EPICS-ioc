## GALILCRATE set prior to call

## GALILCRATE is the galil crate number - 01, 02, ...

#Load motor records for real and coordinate system (CS) motors
dbLoadRecords("$(TOP)/db/galil_motors.db", "P=$(MYPVPREFIX)MOT:,CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")

#Load DMC controller features (eg.  Limit switch type, home switch type, output compare, message consoles)
#Load extra functionality, untop of motorRecord features for axis/motors (eg. runtime gear ratio changes between master & slaves)
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_dmc_ctrl.db", "P=$(MYPVPREFIX)MOT:,CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")

#Load extra features for real axis/motors (eg. Motor type, encoder type)
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_motor_extras.db", "P=$(MYPVPREFIX)MOT:,CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")

#Load digital IO databases
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_digital_ports.db", "P=$(MYPVPREFIX)MOT:,CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")

#Load analog IO databases
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_analog_ports.db", "P=$(MYPVPREFIX)MOT:,CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")

#Load kinematics for CS axis/motors (eg. Forward and reverse kinematics, kinematic variables)
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_csmotor_kinematics.db", "P=$(MYPVPREFIX)MOT:,CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")

#Load coordinate system features (eg. Coordinate system S and T status, motor list, segments processed, moving status)
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_coordinate_systems.db", "P=$(MYPVPREFIX)MOT:,CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")

#Load user defined functions
#dbLoadRecords("$(TOP)/db/galil_userdef_records.db", "P=$(MYPVPREFIX)MOT:,CC=$(GCID),CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_userdef_records8.db", "P=$(MYPVPREFIX)MOT:,CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")

#Load user defined array support
dbLoadRecords("$(TOP)/db/galil_user_array.db","P=$(MYPVPREFIX)MOT:,CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")

#Load profiles
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_profileMoveController.db", "P=$(MYPVPREFIX)MOT:,CC=$(GCID),CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_profileMoveAxis.db", "P=$(MYPVPREFIX)MOT:,CC=$(GCID),CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")

