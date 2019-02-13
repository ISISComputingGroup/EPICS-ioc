# Check for an address entry, without this do not load
stringiftest "ADR" "$(CHAIN$(CHAIN)_ADR$(PS)=)" 1

stringiftest "ID" "$(CHAIN$(CHAIN)_ID$(PS)=)" 1

# Default the name to the Address
$(IFADR) $(IFNOTID) epicsEnvSet "PSUNAME" "$(CHAIN$(CHAIN)_ADR$(PS)=)"
$(IFADR) $(IFID) epicsEnvSet "PSUNAME" "$(CHAIN$(CHAIN)_ID$(PS)=)"

$(IFADR) epicsEnvSet "PSUID" "$(CHAIN$(CHAIN)_ADR$(PS)=)"

$(IFADR) dbLoadRecords("$(TOP)/db/DFKPS_RIKEN.db", "device=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME):$(PSUNAME):, port=$(DEVICE),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0), powpos=$(PFP$(PS)=$(POWER_FLAG_POSITION)), ilkpos=$(CHAIN$(CHAIN)_ILK$(PS)=$(INTERLOCK_FLAG_POSITION)), VADC=$(VADC$(PS)=2), FWI=$(CHAIN$(CHAIN)_FWI$(PS)=1000), FRI=$(CHAIN$(CHAIN)_FRI$(PS)=1), FRV=$(CHAIN$(CHAIN)_FRV$(PS)=1), ADR=$(PSUID)")
