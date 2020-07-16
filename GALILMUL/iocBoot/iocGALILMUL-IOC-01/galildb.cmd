## MTRCTRL set prior to call

## MTRCTRL is the galil crate number - 01, 02, ...

## GALIL_MTR_PORT will be Galil or GalilSim
dbLoadRecords("$(TOP)/db/galil_motor.db", "PORT=$(GALIL_MTR_PORT),P=$(MYPVPREFIX)MOT,CCP=$(MTRCTRL)")

#Load extra functionality, untop of motorRecord features for axis/motors (eg. runtime gear ratio changes between master & slaves)
dbLoadRecords("$(TOP)/db/galil_ctrl_extras.db", "P=$(MYPVPREFIX)MOT,CCP=$(MTRCTRL),PORT=$(GALIL_MTR_PORT)")
dbLoadRecords("$(TOP)/db/galil_motor_extras.db", "P=$(MYPVPREFIX)MOT,CCP=$(MTRCTRL),PVPREFIX=$(MYPVPREFIX),ASG01=$(ASG01=DEFAULT),ASG02=$(ASG02=DEFAULT),ASG03=$(ASG03=DEFAULT),ASG04=$(ASG04=DEFAULT),ASG05=$(ASG05=DEFAULT),ASG06=$(ASG06=DEFAULT),ASG07=$(ASG07=DEFAULT),ASG08=$(ASG08=DEFAULT),PORT=$(GALIL_MTR_PORT)")

#Load digital IO databases
dbLoadRecords("$(TOP)/db/galil_digital_ports.db", "P=$(MYPVPREFIX)MOT,CCP=$(MTRCTRL),PORT=$(GALIL_MTR_PORT)")

#Load analog IO databases
dbLoadRecords("$(TOP)/db/galil_analog_ports.db", "P=$(MYPVPREFIX)MOT,CCP=$(MTRCTRL),PORT=$(GALIL_MTR_PORT)")

#Load user defined functions
dbLoadRecords("$(TOP)/db/galil_userdef_records8.db", "P=$(MYPVPREFIX)MOT,CCP=$(MTRCTRL),PORT=$(GALIL_MTR_PORT)")

dbLoadRecords("$(TOP)/db/galil_profileMoveController.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL),PORT=$(GALIL_MTR_PORT)")
dbLoadRecords("$(TOP)/db/galil_profileMoveAxis.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL),PORT=$(GALIL_MTR_PORT)")
