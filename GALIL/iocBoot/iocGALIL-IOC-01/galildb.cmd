## MTRCTRL set prior to call

## MTRCTRL is the galil crate number - 01, 02, ...

## GALIL_MTR_PORT will be Galil or GalilSim
dbLoadRecords("$(TOP)/db/galil_motors.db", "GPORT=$(GALIL_MTR_PORT),P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

#Load DMC controller features (eg.  Limit switch type, home switch type, output compare, message consoles)
#Load extra functionality, untop of motorRecord features for axis/motors (eg. runtime gear ratio changes between master & slaves)
dbLoadRecords("$(TOP)/db/galil_dmc_ctrl.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

#Load extra features for real axis/motors (eg. Motor type, encoder type)
dbLoadRecords("$(TOP)/db/galil_motor_extras.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL),PVPREFIX=$(MYPVPREFIX),ASG01=$(ASG01=DEFAULT),ASG02=$(ASG02=DEFAULT),ASG03=$(ASG03=DEFAULT),ASG04=$(ASG04=DEFAULT),ASG05=$(ASG05=DEFAULT),ASG06=$(ASG06=DEFAULT),ASG07=$(ASG07=DEFAULT),ASG08=$(ASG08=DEFAULT),ENCAVNSAMP=$(ENCAVNSAMP=10),IOCNAME=$(IOCNAME)")

#Load extra features for CS axis/motors (eg. Setpoint monitor)
dbLoadRecords("$(TOP)/db/galil_csmotor_extras.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

#Load kinematics for CS axis/motors (eg. Forward and reverse kinematics, kinematic variables)
dbLoadRecords("$(TOP)/db/galil_csmotor_kinematics.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

#Load coordinate system features (eg. Coordinate system S and T status, motor list, segments processed, moving status)
dbLoadRecords("$(TOP)/db/galil_coordinate_systems.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

#Load digital IO databases
dbLoadRecords("$(TOP)/db/galil_digital_ports.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL),RECSIM=$(RECSIM), IFNOTSIM=$(IFNOTSIM)")

#Load analog IO databases
dbLoadRecords("$(TOP)/db/galil_analog_ports.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

#Load user defined functions
dbLoadRecords("$(TOP)/db/galil_userdef_records8.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

#load user arrays
dbLoadRecords("$(TOP)/db/galil_user_array.db","P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

#Load profiles
dbLoadRecords("$(TOP)/db/galil_profileMoveController.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")
dbLoadRecords("$(TOP)/db/galil_profileMoveAxis.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

#Load homing routine records 
dbLoadRecords("$(TOP)/db/galil_homing_routines.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")
