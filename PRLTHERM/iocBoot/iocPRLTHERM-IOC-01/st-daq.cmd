epicsEnvSet("CDAQ","$(HOST=PEARL_cDAQ_ChassisMod1)") # PEARL cDAQ chassis and module address (appended 'Mod1')

## 16 x temperature inputs from a cDAQ 9181 chassis with a 9213 thermocouple module

## DAQmxBaseConfig (portName, deviceName, Channelnr, acqType, options)
## portName - ASYN port name to create or to add to
## devicename - NI device name (e.g. dev1/ai0)
## Channelnr - Channelnr inside ASYN port (start with 0)
## acqType - “AI” ,”AO”, “BI”, “BO”, “COUNTER” or "AITC"
## options - see DAQmx Port Options

# All channels configured for units of Kelvin and K-Type thermocouples (values from VI: m=73.15 M=1645.15)

$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai0",   0, "AITC", "OneShot N=2 F=0 m=73.15 M=1645")      # Channel  0
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai1",   1, "AITC", "OneShot N=2 F=0 m=73.15 M=1645")      # Channel  1
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai2",   2, "AITC", "OneShot N=2 F=0 m=73.15 M=1645")      # Channel  2
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai3",   3, "AITC", "OneShot N=2 F=0 m=73.15 M=1645")      # Channel  3
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai4",   4, "AITC", "OneShot N=2 F=0 m=73.15 M=1645")      # Channel  4
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai5",   5, "AITC", "OneShot N=2 F=0 m=73.15 M=1645")      # Channel  5
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai6",   6, "AITC", "OneShot N=2 F=0 m=73.15 M=1645")      # Channel  6
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai7",   7, "AITC", "OneShot N=2 F=0 m=73.15 M=1645")      # Channel  7
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai8",   8, "AITC", "OneShot N=2 F=0 m=73.15 M=1645")      # Channel  8
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai9",   9, "AITC", "OneShot N=2 F=0 m=73.15 M=1645")      # Channel  9
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai10", 10, "AITC", "OneShot N=2 F=0 m=73.15 M=1645")      # Channel 10
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai11", 11, "AITC", "OneShot N=2 F=0 m=73.15 M=1645")      # Channel 11
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai12", 12, "AITC", "OneShot N=2 F=0 m=73.15 M=1645")      # Channel 12
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai13", 13, "AITC", "OneShot N=2 F=0 m=73.15 M=1645")      # Channel 13
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai14", 14, "AITC", "OneShot N=2 F=0 m=73.15 M=1645")      # Channel 14
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai15", 15, "AITC", "OneShot N=2 F=0 m=73.15 M=1645")      # Channel 15
