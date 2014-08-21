# Create simulated motors: ( start card , start axis , low limit, high limit, home posn, # cards, # axes to setup)
motorSimCreate( 0, 0, -32000, 32000, 0, $(GALILNUMCRATES), 8 )

# Setup the Asyn layer (portname, low-level driver drvet name, card, number of axes on card)
# number crates from 0
calc("GCID", "0", 2, 2)
$(IFDMC01) drvAsynMotorConfigure("motorSim$(GCID)", "motorSim", $(GCID), 8)
$(IFDMC01) calc("GCID", "$(GCID) + 1", 2, 2)
$(IFDMC02) drvAsynMotorConfigure("motorSim$(GCID)", "motorSim", $(GCID), 8)
$(IFDMC02) calc("GCID", "$(GCID) + 1", 2, 2)
$(IFDMC03) drvAsynMotorConfigure("motorSim$(GCID)", "motorSim", $(GCID), 8)
$(IFDMC03) calc("GCID", "$(GCID) + 1", 2, 2)
$(IFDMC04) drvAsynMotorConfigure("motorSim$(GCID)", "motorSim", $(GCID), 8)
$(IFDMC04) calc("GCID", "$(GCID) + 1", 2, 2)
$(IFDMC05) drvAsynMotorConfigure("motorSim$(GCID)", "motorSim", $(GCID), 8)
$(IFDMC05) calc("GCID", "$(GCID) + 1", 2, 2)
$(IFDMC06) drvAsynMotorConfigure("motorSim$(GCID)", "motorSim", $(GCID), 8)
$(IFDMC06) calc("GCID", "$(GCID) + 1", 2, 2)
$(IFDMC07) drvAsynMotorConfigure("motorSim$(GCID)", "motorSim", $(GCID), 8)
$(IFDMC07) calc("GCID", "$(GCID) + 1", 2, 2)
