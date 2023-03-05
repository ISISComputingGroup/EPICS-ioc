##
## note: DESC is limited to 40 characters
##

dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigStringParam.db","EPARAM=SYS:SN,DPARAM=system.serialnumber,DESC=Serial number of the DAQ,P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigStringParam.db","EPARAM=SYS:SW:VERSION,DPARAM=system.swversion,DESC=Version of the ZYNQ software,P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigStringParam.db","EPARAM=SYS:COMPILE_DATA,DPARAM=system.compile_data,DESC=Date of build of ZYNQ software,P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigStringParam.db","EPARAM=SYS:IPADDR,DPARAM=system.ipaddress,DESC=IP address of DAQ,P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigStringParam.db","EPARAM=DGTZ:PROBES:FWVER,DPARAM=dgtz.probes.fwver,DESC=Version of the FPGA firmware,P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")

dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigIntegerParam.db","EPARAM=SYS:BASECONN,DPARAM=system.baseconnected,DESC=Base detected,P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigIntegerParam.db","EPARAM=SYS:MEMORY,DPARAM=system.availableram,DESC=Available DAQ Ram,P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigIntegerParam.db","EPARAM=TRIG:RATE,DPARAM=trg.self_rate,DESC=Internal gen freq in periodic mode,EGU=Hz,P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigIntegerParam.db","EPARAM=TRIG:RATE,DPARAM=trg.self_rate,DESC=Internal gen freq in periodic mode,EGU=Hz,P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")

dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigRealParam.db","EPARAM=SYS:CPULOAD,DPARAM=system.cpuload,DESC=CPU Load,EGU=%,P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigRealParam.db","EPARAM=SYS:TSYS:CORE,DPARAM=system.Tsys.core,DESC=Zynq core temp,EGU=C,P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigRealParam.db","EPARAM=SYS:TSYS:ADC,DPARAM=system.Tsys.adc,DESC=ADC temp,EGU=C,P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigRealParam.db","EPARAM=SYS:TSYS:DGTZ,DPARAM=system.Tsys.dgtz,DESC=Digitiser board temp,EGU=C,P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigRealParam.db","EPARAM=SYS:TSYS:BASE,DPARAM=system.Tsys.base,DESC=Base temp,EGU=C,P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")

dbLoadRecordsLoop("$(NUCINSTDIG)/db/NucInstDigRealParamChan.db","EPARAM=STAVE:T:PROBES:TSIPM,DPARAM=stave.T.probes.Tsipm,CHAN=\$(I),EGU=C,DESC=Temperatures of SiPM,P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0", "I", 0, 23)
dbLoadRecordsLoop("$(NUCINSTDIG)/db/NucInstDigRealParamChan.db","EPARAM=STAVE:BIAS:PROBES:VSIPM,DPARAM=stave.BIAS.probes.Vsipm,CHAN=\$(I),EGU=V,DESC=Voltage applied to SiPM,P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0", "I", 0, 23)
dbLoadRecordsLoop("$(NUCINSTDIG)/db/NucInstDigRealParamChan.db","EPARAM=STAVE:BIAS:PROBES:CORR,DPARAM=stave.BIAS.probes.correction,CHAN=\$(I),EGU=V,DESC=HV correction for SiPM,P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0", "I", 0, 23)
