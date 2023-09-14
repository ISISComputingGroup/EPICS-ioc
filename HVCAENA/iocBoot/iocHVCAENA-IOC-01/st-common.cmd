##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

iocshLoad "${TOP}/iocBoot/iocHVCAENA-IOC-01/st-crate.cmd" "INDEX=0"
iocshLoad "${TOP}/iocBoot/iocHVCAENA-IOC-01/st-crate.cmd" "INDEX=1"
iocshLoad "${TOP}/iocBoot/iocHVCAENA-IOC-01/st-crate.cmd" "INDEX=2"
iocshLoad "${TOP}/iocBoot/iocHVCAENA-IOC-01/st-crate.cmd" "INDEX=3"
iocshLoad "${TOP}/iocBoot/iocHVCAENA-IOC-01/st-crate.cmd" "INDEX=4"
iocshLoad "${TOP}/iocBoot/iocHVCAENA-IOC-01/st-crate.cmd" "INDEX=5"
iocshLoad "${TOP}/iocBoot/iocHVCAENA-IOC-01/st-crate.cmd" "INDEX=6"
iocshLoad "${TOP}/iocBoot/iocHVCAENA-IOC-01/st-crate.cmd" "INDEX=7"

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
