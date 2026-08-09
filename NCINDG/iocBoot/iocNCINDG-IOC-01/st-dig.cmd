
nucInstDigConfigure("DIG$(DIG)", "$(IP_ADDR)", $(INDEX))

stringiftest("DIG0", "$(DIG=)", 5, "0")

## Load our record instances
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDig.db","P=$(MYPVPREFIX),Q=$(IOCNAME):D$(DIG):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG$(DIG),IFDIG0=$(IFDIG0)")
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigTrace.db","P=$(MYPVPREFIX),Q=$(IOCNAME):D$(DIG):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG$(DIG)")
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigDCSpec.db","P=$(MYPVPREFIX),Q=$(IOCNAME):D$(DIG):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG$(DIG)")
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigTOFSpec.db","P=$(MYPVPREFIX),Q=$(IOCNAME):D$(DIG):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG$(DIG)")

iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/liveview.cmd", "DIG=$(DIG),LVDET=1,LVADDR=0"
iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/liveview.cmd", "DIG=$(DIG),LVDET=2,LVADDR=1"
iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/liveview.cmd", "DIG=$(DIG),LVDET=3,LVADDR=2"

$(IFDIG0) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/liveview.cmd", "DIG=0,LVDET=4,LVADDR=3"
$(IFDIG0) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/liveview.cmd", "DIG=0,LVDET=5,LVADDR=4"
$(IFDIG0) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/liveview.cmd", "DIG=0,LVDET=6,LVADDR=5,DATATYPE=4,TYPE=Int32,FTVL=LONG"

iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/digitiser-params.cmd", "DIG=$(DIG)"
