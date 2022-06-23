
stringiftest("IPPresent", "$(IP_ADDRESS_$(INDEX)="")", 13, "")
$(IFNOTIPPresent) exit

## we used to have the global READ_ONLY variable, now allow a per crate default
CAENHVAsynReadOnly($(READ_ONLY_$(INDEX)=$(READ_ONLY=0)))

CAENHVAsynSetEpicsPrefix("$(MYPVPREFIX)$(IOCNAME):HV$(INDEX):")
CAENHVAsynConfig("HV$(INDEX)",$(SYS_TYPE_$(INDEX)),"$(IP_ADDRESS_$(INDEX))","admin","admin")
