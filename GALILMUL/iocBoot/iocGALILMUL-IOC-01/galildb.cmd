## MTRCTRL set prior to call

## MTRCTRL is the galil crate number - 01, 02, ...

## GALIL_MTR_PORT will be Galil* or GalilSim*
## GALIL_PORT will be Galil*
dbLoadRecords("$(GALILIOC)/db/galil_motors.db", "GPORT=$(GALIL_MTR_PORT),P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL),PORT=$(GALIL_PORT)")

#Load DMC controller features (eg.  Limit switch type, home switch type, output compare, message consoles)
#Load extra functionality, untop of motorRecord features for axis/motors (eg. runtime gear ratio changes between master & slaves)
dbLoadRecords("$(GALILIOC)/db/galil_dmc_ctrl.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL),PORT=$(GALIL_PORT)")

#Load extra features for real axis/motors (eg. Motor type, encoder type)
dbLoadRecords("$(GALILIOC)/db/galil_motor_extras.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL),PVPREFIX=$(MYPVPREFIX),PORT=$(GALIL_PORT),ASG01=$(ASG01=DEFAULT),ASG02=$(ASG02=DEFAULT),ASG03=$(ASG03=DEFAULT),ASG04=$(ASG04=DEFAULT),ASG05=$(ASG05=DEFAULT),ASG06=$(ASG06=DEFAULT),ASG07=$(ASG07=DEFAULT),ASG08=$(ASG08=DEFAULT)")

#Load extra features for CS axis/motors (eg. Setpoint monitor)
dbLoadRecords("$(GALILIOC)/db/galil_csmotor_extras.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL),PORT=$(GALIL_PORT)")

#Load kinematics for CS axis/motors (eg. Forward and reverse kinematics, kinematic variables)
dbLoadRecords("$(GALILIOC)/db/galil_csmotor_kinematics.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL),PORT=$(GALIL_PORT)")

#Load coordinate system features (eg. Coordinate system S and T status, motor list, segments processed, moving status)
dbLoadRecords("$(GALILIOC)/db/galil_coordinate_systems.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL),PORT=$(GALIL_PORT)")

#Load digital IO databases
dbLoadRecords("$(GALILIOC)/db/galil_digital_ports.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL),PORT=$(GALIL_PORT)")

#Load analog IO databases
dbLoadRecords("$(GALILIOC)/db/galil_analog_ports.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL),PORT=$(GALIL_PORT)")

#Load user defined functions
dbLoadRecords("$(GALILIOC)/db/galil_userdef_records8.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL),PORT=$(GALIL_PORT)")

#load user arrays
dbLoadRecords("$(GALILIOC)/db/galil_user_array.db","P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL),PORT=$(GALIL_PORT)")

#Load profiles
dbLoadRecords("$(GALILIOC)/db/galil_profileMoveController.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL),PORT=$(GALIL_PORT)")
dbLoadRecords("$(GALILIOC)/db/galil_profileMoveAxis.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL),PORT=$(GALIL_PORT)")
