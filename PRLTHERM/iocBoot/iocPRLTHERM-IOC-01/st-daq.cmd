epicsEnvSet("CDAQ","$(HOST=localhost)Mod1") # cDAQ chassis address (appended 'Mod1' for thermocouple module)

## 16 x temperature inputs from a cDAQ 9181 chassis with a 9213 thermocouple module

## DAQmxBaseConfig (portName, deviceName, Channelnr, acqType, options)
## portName - ASYN port name to create or to add to
## devicename - NI device name (e.g. dev1/ai0)
## Channelnr - Channelnr inside ASYN port (start with 0)
## acqType - “AI” ,”AO”, “BI”, “BO”, “COUNTER” or "AITC"
## options - see DAQmx Port Options

# By default, all channels configured for units of Kelvin and K-Type thermocouples (values from VI: m=73.15 M=1645.15)
# Number of samples (N)=2; Sampling Frequency (F)=1; Minumum Value (m)=73.15; Maximum Value (M)=1645.15

epicsEnvSet("DAQMX_OPTIONS", "N=2 F=1 m=$(MIN_TEMP=73.15) M=$(MAX_TEMP=1645.15) U=$(UNITS=Kelvins) thermocoupleType=$(TC_TYPE=K_Type_TC) cjcSource=$(CJC_SOURCE=ConstVal) cjcVal=$(CJC_VAL=25.0) cjcChannel=$(CJC_CHANNEL=0) AIADCTimingMode=HighResolution AIAutoZeroMode=Once")

$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai0",   0, "AITC", "$(DAQMX_OPTIONS)")      # Channel  0
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai1",   1, "AITC", "$(DAQMX_OPTIONS)")      # Channel  1
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai2",   2, "AITC", "$(DAQMX_OPTIONS)")      # Channel  2
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai3",   3, "AITC", "$(DAQMX_OPTIONS)")      # Channel  3
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai4",   4, "AITC", "$(DAQMX_OPTIONS)")      # Channel  4
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai5",   5, "AITC", "$(DAQMX_OPTIONS)")      # Channel  5
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai6",   6, "AITC", "$(DAQMX_OPTIONS)")      # Channel  6
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai7",   7, "AITC", "$(DAQMX_OPTIONS)")      # Channel  7
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai8",   8, "AITC", "$(DAQMX_OPTIONS)")      # Channel  8
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai9",   9, "AITC", "$(DAQMX_OPTIONS)")      # Channel  9
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai10", 10, "AITC", "$(DAQMX_OPTIONS)")      # Channel 10
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai11", 11, "AITC", "$(DAQMX_OPTIONS)")      # Channel 11
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai12", 12, "AITC", "$(DAQMX_OPTIONS)")      # Channel 12
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai13", 13, "AITC", "$(DAQMX_OPTIONS)")      # Channel 13
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai14", 14, "AITC", "$(DAQMX_OPTIONS)")      # Channel 14
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai15", 15, "AITC", "$(DAQMX_OPTIONS)")      # Channel 15
