## MTRCTRL set prior to call

## MTRCTRL is the galil crate number - 01, 02, ...

## GALIL_MTR_PORT will be Galil or GalilSim
dbLoadRecords("$(TOP)/db/galil_motors.db", "PORT=$(GALIL_MTR_PORT),P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

#Load DMC controller features (eg.  Limit switch type, home switch type, output compare, message consoles)
#Load extra functionality, untop of motorRecord features for axis/motors (eg. runtime gear ratio changes between master & slaves)
dbLoadRecords("$(TOP)/db/galil_dmc_ctrl.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

#Load extra features for real axis/motors (eg. Motor type, encoder type)
dbLoadRecords("$(TOP)/db/galil_motor_extras.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

#Load digital IO databases
dbLoadRecords("$(TOP)/db/galil_digital_ports.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

#Load analog IO databases
dbLoadRecords("$(TOP)/db/galil_analog_ports.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

#Load kinematics for CS axis/motors (eg. Forward and reverse kinematics, kinematic variables)
dbLoadRecords("$(TOP)/db/galil_csmotor_kinematics.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

#Load coordinate system features (eg. Coordinate system S and T status, motor list, segments processed, moving status)
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_coordinate_systems.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

#Load user defined functions
dbLoadRecords("$(TOP)/db/galil_userdef_records8.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_profileMoveAxis.db", "P=$(MYPVPREFIX)MOT:,CC=$(GCID),CCP=$(GALILCRATE),IFSIM=$(IFSIM),IFNOTSIM=$(IFNOTSIM)")
dbLoadRecords("$(TOP)/db/galil_user_array.db","P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")
dbLoadRecords("$(TOP)/db/galil_profileMoveAxis.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

#Load profiles
#$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_profileMoveController.db", "P=$(MYPVPREFIX)MOT:,CC=$(GCID),CCP=$(MTRCTRL)")
#$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_profileMoveAxis.db", "P=$(MYPVPREFIX)MOT:,CC=$(GCID),CCP=$(MTRCTRL)")

