# Exercise the JASCO PU-4180
############################
# The Jasco 4180 device software has a known race condition (see wiki:
# https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/JASCO-PU--4180-HPLC-Pump#troubleshooting) 
# that causes the device 
# to freeze. This script attempts to crash the device and can be used for testing purposes 
# in the event the driver is updated. The driver has been design to have resilience against 
# this crash condition and should (in theory) never fail.
#
from genie_python import genie as g

def exercise_pump(attempts=2000):

    attempts = attempts
    check_freq = attempts/10

    g.set_pv("JSCO4180_01:COMP:A:SP", 25, is_local=True)
    g.set_pv("JSCO4180_01:COMP:B:SP", 25, is_local=True)
    g.set_pv("JSCO4180_01:COMP:C:SP", 25, is_local=True)

    g.set_pv("JSCO4180_01:FLOWRATE:SP", 0.01, is_local=True)

    print("Starting crash test of JASCO PU-4180:")
    for i in range(attempts):
        g.set_pv("JSCO4180_01:PUMP_FOR_TIME:SP", "Start", is_local=True)
        if i%check_freq == 0:
            print("Current iteration: {0}".format(i))
            alarm = g.get_pv("JSCO4180_01:COMP:A.STAT", is_local=True)
            print("Alarm status: {alarm}".format(alarm=alarm))
            if alarm == "TIMEOUT":
                print("Record timeout - Device most likely crashed at iteration: {0}".format(i))
                break
    else:
        g.set_pv("JSCO4180_01:STOP:SP", "Stop", is_local=True)
        print("Script finished: Pump was not crashed")
