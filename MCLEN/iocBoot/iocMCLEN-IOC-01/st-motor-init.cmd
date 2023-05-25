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

## end of move check window, allowed difference at end of move
asynOctetWrite("MKINIT","$(MN)WI$(WINI)")

## Not Complete/Time-Out time
asynOctetWrite("MKINIT","$(MN)TO8000")

## tracking window, allowed difference between motor and encoder when moving
## get tracking abort if exceeded
asynOctetWrite("MKINIT","$(MN)TR4000")

## SL1 enables soft limits in controller, SL0 disables
## we disable for now until we are sure they work
## see comment in driver
asynOctetWrite("MKINIT","$(MN)SL0")

## backoff steps as 0
asynOctetWrite("MKINIT","$(MN)BO$(BOSTI)")

## creep steps at end of move, 10 is default for stepper
asynOctetWrite("MKINIT","$(MN)CR$(CRSTI)")

## creep speed, 800 is default
asynOctetWrite("MKINIT","$(MN)CS800")

## settle time, how long must remain in Window at end of move, 100 is default
asynOctetWrite("MKINIT","$(MN)SE$(SETLI)")

## set abort mode, controller default is 00000000
## however passing 00111000 for example would make stall error, tracking error and timeout error not abort motion 
asynOctetWrite("MKINIT","$(MN)AM00000000")

## set datum mode, controller default is 00000000
## this also controls expected encoder index polarity, automatic direction search etc. on datum
## so not set at moment in case mess up encoder? It is partly adjusted in the main
## driver depending on homing mode
#asynOctetWrite("MKINIT","$(MN)DM00000000")

## note: SH command generally not set here, if we chose appropriate hardware home
## main driver will do a SH0 before homing to datum if in appropriate mode
#asynOctetWrite("MKINIT","$(MN)SH0")
