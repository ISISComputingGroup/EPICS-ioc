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

dcalc("TREAD","$(NUM_SENSORS)*0.2",1,3)
dcalc("TDLY","$(TREAD)/2",1,3)
