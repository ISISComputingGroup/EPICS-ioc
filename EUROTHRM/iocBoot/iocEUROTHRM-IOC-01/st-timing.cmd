epicsEnvSet "NUM_SENSORS" 0

stringiftest("ACTIVE", "$(ADDR_1=)")
$(IFACTIVE) calc("NUM_SENSORS", "$(NUM_SENSORS)+1",1,1)
stringiftest("ACTIVE", "$(ADDR_2=)")
$(IFACTIVE) calc("NUM_SENSORS", "$(NUM_SENSORS)+1",1,1)
stringiftest("ACTIVE", "$(ADDR_3=)")
$(IFACTIVE) calc("NUM_SENSORS", "$(NUM_SENSORS)+1",1,1)
stringiftest("ACTIVE", "$(ADDR_4=)")
$(IFACTIVE) calc("NUM_SENSORS", "$(NUM_SENSORS)+1",1,1)
stringiftest("ACTIVE", "$(ADDR_5=)")
$(IFACTIVE) calc("NUM_SENSORS", "$(NUM_SENSORS)+1",1,1)
stringiftest("ACTIVE", "$(ADDR_6=)")
$(IFACTIVE) calc("NUM_SENSORS", "$(NUM_SENSORS)+1",1,1)
stringiftest("ACTIVE", "$(ADDR_7=)")
$(IFACTIVE) calc("NUM_SENSORS", "$(NUM_SENSORS)+1",1,1)

stringiftest("ACTIVE", "$(ADDR_8=)")
$(IFACTIVE) calc("NUM_SENSORS", "$(NUM_SENSORS)+1",1,1)

stringiftest("ACTIVE", "$(ADDR_9=)")
$(IFACTIVE) calc("NUM_SENSORS", "$(NUM_SENSORS)+1",1,1)

stringiftest("ACTIVE", "$(ADDR_10=)")
$(IFACTIVE) calc("NUM_SENSORS", "$(NUM_SENSORS)+1",1,1)

epicsEnvSet "MAX_RECORDS_PER_READ" 3

## Edit this one if you want to tune the Eurotherm performance.
## If it is too short, records will return TIMEOUT INVALID and the
## OPI will report disconnections and appear unresponsive
epicsEnvSet "SECONDS_PER_READ" 0.08

dcalc("TDLY","$(NUM_SENSORS)*$(SECONDS_PER_READ)",1,3)
dcalc("TREAD","$(TDLY)*$(MAX_RECORDS_PER_READ)",1,3)
