## MTRCTRL set prior to call

## MTRCTRL is the galil crate number - 01, 02, ...

dbLoadRecords("$(TOP)/db/galil_motor.db", "PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)MOT,CCP=$(MTRCTRL),ASG01=$(ASG01=DEFAULT),ASG02=$(ASG02=DEFAULT),ASG03=$(ASG03=DEFAULT),ASG04=$(ASG04=DEFAULT),ASG05=$(ASG05=DEFAULT),ASG06=$(ASG06=DEFAULT),ASG07=$(ASG07=DEFAULT),ASG08=$(ASG08=DEFAULT)")

#Load extra functionality, untop of motorRecord features for axis/motors (eg. runtime gear ratio changes between master & slaves)
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_ctrl_extras.db", "P=$(MYPVPREFIX)MOT,CCP=$(MTRCTRL)")
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_motor_extras.db", "P=$(MYPVPREFIX)MOT,CCP=$(MTRCTRL)")

#Load digital IO databases
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_digital_ports.db", "P=$(MYPVPREFIX)MOT,CCP=$(MTRCTRL)")

#Load analog IO databases
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_analog_ports.db", "P=$(MYPVPREFIX)MOT,CCP=$(MTRCTRL)")

#Load user defined functions
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_userdef_records8.db", "P=$(MYPVPREFIX)MOT,CCP=$(MTRCTRL)")

$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_profileMoveController.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")
$(IFNOTSIM) dbLoadRecords("$(TOP)/db/galil_profileMoveAxis.db", "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")
