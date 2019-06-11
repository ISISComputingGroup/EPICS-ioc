#
#
#
# Fermi chopper IOC starting.
#
#
#


#!../../bin/windows-x64/FERMCHOP-IOC-01

## You may have to change FERMCHOP-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(FERMCHOP)/data"
epicsEnvSet "DEVICE" "L0"

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/FERMCHOP-IOC-01.dbd"
FERMCHOP_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## For unit testing:
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=)")

## For normal devsim:
# $(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:57677")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

# For real device:
# Configure using standard asyn serial:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)

# Configure to use VISA serial library instead of asynSerial (probably don't need to use this)
# $(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynVISAPortConfigure("$(DEVICE)","$(PORT=NO_PORT_MACRO)",0,0,0,0,"",0)

$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "rbuff", "128")  # set read buffer
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "wbuff", "16")   # set write buffer
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "flush", "Y")    # flush after every write

$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "baud", "$(BAUD=9600)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "bits", "$(BITS=8)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "parity", "$(PARITY=none)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "stop", "$(STOP=1)")

$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", 0, "crtscts","N")

$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixon","N") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixoff","N") 


## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

epicsEnvSet "P" "$(MYPVPREFIX)$(IOCNAME):"

## Load our record instances
dbLoadRecords("db/fermchop.db","PVPREFIX=$(MYPVPREFIX),P=$(P),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),ASG=$(ASG=DEFAULT),INST=$(INST=merlin),MHZ=$(MHZ=50.4)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start programs to keep setpoints and readbacks in sync with each other.
seq keep_sp_and_rbv_in_sync, "SETPOINT=$(P)DELAY:SP,READBACK=$(P)DELAY:SP:RBV,TOLERANCE=$(P)DELAY:_SEQ_TOL,DELAY=$(P)DELAY:_SEQ_DELAY"
seq keep_sp_and_rbv_in_sync, "SETPOINT=$(P)GATEWIDTH:SP,READBACK=$(P)GATEWIDTH,TOLERANCE=$(P)GATEWIDTH:_SEQ_TOL,DELAY=$(P)GATEWIDTH:_SEQ_DELAY"
seq keep_sp_and_rbv_in_sync, "SETPOINT=$(P)SPEED:SP,READBACK=$(P)SPEED:SP:RBV,TOLERANCE=$(P)SPEED:_SEQ_TOL,DELAY=$(P)SPEED:_SEQ_DELAY"

# Set up logging when the status reported by the controller changes
seq error_logger, "INPUT_PV=$(P)STATUS.B0,OFF_STR=Microcontroller_error,ON_STR=Microcontroller_OK"
seq error_logger, "INPUT_PV=$(P)STATUS.B1,OFF_STR=Nominal_speed_not_reached,ON_STR=Nominal_speed_reached"
seq error_logger, "INPUT_PV=$(P)STATUS.B2,OFF_STR=Actual_delay_not_within_gate,ON_STR=Actual_delay_within_gate"
seq error_logger, "INPUT_PV=$(P)STATUS.B3,OFF_STR=Magnetic_bearings_off,ON_STR=Magnetic_bearings_on"
seq error_logger, "INPUT_PV=$(P)STATUS.B4,OFF_STR=DC_supply_voltage_off,ON_STR=DC_supply_voltage_on"
seq error_logger, "INPUT_PV=$(P)STATUS.B5,OFF_STR=Drive_generator_off,ON_STR=Drive_generator_on"
seq error_logger, "INPUT_PV=$(P)STATUS.B7,OFF_STR=Interlock_OK,ON_STR=Interlock_active"
seq error_logger, "INPUT_PV=$(P)STATUS.BA,OFF_STR=Controller_reports_speed_within_limit,ON_STR=Controller_reports_speed_limit_exceeded"
seq error_logger, "INPUT_PV=$(P)STATUS.BB,OFF_STR=Bearing_speed_check_OK,ON_STR=Bearings_off_with_chopper_at_speed"
seq error_logger, "INPUT_PV=$(P)STATUS.BC,OFF_STR=Controller_reports_autozero_voltages_OK,ON_STR=Controller_reports_autozero_voltages_out_of_range"
seq error_logger, "INPUT_PV=$(P)STATUS.BD,OFF_STR=Controller_reports_chopper_speed_OK,ON_STR=Controller_reports_chopper_overspeed"

# Set up logging when the software safety checks are triggered
seq error_logger, "INPUT_PV=$(P)STATUS:_SAFETYCHECKS:CHOPSPEED,OFF_STR=Software_reports_chopper_speed_OK,ON_STR=Software_detected_chopper_overspeed_(this_will_cause_the_chopper_drive_to_turn_off)"
seq error_logger, "INPUT_PV=$(P)STATUS:_SAFETYCHECKS:BEARING,OFF_STR=Software_bearing_speed_check_OK,ON_STR=Software_detected_chopper_at_speed_with_bearing_off_(this_will_cause_the_chopper_to_spin_down)"
seq error_logger, "INPUT_PV=$(P)STATUS:_SAFETYCHECKS:AUTOZERO,OFF_STR=Software_autozero_checks_OK,ON_STR=Software_detected_autozero_voltages_out_of_range_with_chopper_on_(this_will_cause_the_chopper_to_spin_down)"
seq error_logger, "INPUT_PV=$(P)STATUS:_SAFETYCHECKS:MOTORTEMP,OFF_STR=Software_motor_temperature_checks_OK,ON_STR=Software_detected_motor_overheat_(this_will_cause_the_chopper_to_spin_down)"
seq error_logger, "INPUT_PV=$(P)STATUS:_SAFETYCHECKS:ELECTRONICSTEMP,OFF_STR=Software_electronics_temperature_checks_OK,ON_STR=Software_detected_electronics_overheat_(this_will_cause_the_chopper_to_spin_down)"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

# Uncomment these two lines to log every command sent to/from the chopper.
# asynSetTraceIOMask("L0", -1, 0x2)
# asynSetTraceMask("L0", -1, 0x9)


#
#
#
#  Fermi chopper IOC start complete.
#
#
#

