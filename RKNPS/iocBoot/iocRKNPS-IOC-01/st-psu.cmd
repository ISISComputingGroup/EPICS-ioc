# Check for an address entry, without this do not load
stringiftest "ADR" "$(ADR$(PS)=)" 1
stringiftest "ID" "$(ID$(PS)=)" 1

# Default the ID to the Address
$(IFADR) $(IFNOTID) epicsEnvSet "ID$(PS)" $(ADR$(PS))

$(IFADR) dbLoadRecords("$(TOP)/db/DFKPS_RIKEN.db", "device=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME):$(ID$(PS)=$(PS)):, port=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0), powpos=$(PFP$(PS)=$(POWER_FLAG_POSITION)), ilkpos=$(ILK$(PS)=$(INTERLOCK_FLAG_POSITION)), VADC=$(VADC$(PS)=2), FWI=$(FACTOR_WRITE_I$(PS)=1000), FRI=$(FACTOR_READ_I$(PS)=1), FRV=$(FACTOR_READ_V$(PS)=1), ADR=$(ADR$(PS))")
