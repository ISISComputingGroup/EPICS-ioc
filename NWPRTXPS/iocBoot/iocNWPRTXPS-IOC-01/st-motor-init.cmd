## Initialises values at the motor level. Experience suggests the IOC doesn't do this automatically

asynOctetConnect("MKINIT","$(ASERIAL)")

## Some things that are helpful in development mode. Resetting, initialising. Probably don't want to do it in production
#asynOctetWrite("MKINIT","$(MN)RS")
#asynOctetWrite("MKINIT","$(MN)IN")

## Check if open loop mode has been requested
stringiftest("CMOPEN", "$(CMOD$(MN)=)",5,"OPEN")

## Initialise control mode. Defaults to CM14, closed
$(IFCMOPEN) asynOctetWrite("MKINIT","$(MN)CM11")
$(IFNOTCMOPEN) asynOctetWrite("MKINIT","$(MN)CM14")

## Initialise the encoder ratio using the exact string of ERES$
asynOctetWrite("MKINIT","$(MN)ER$(ERES$(MN)=400/4096)")
