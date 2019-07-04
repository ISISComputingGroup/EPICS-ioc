# Exercise the JASCO PU-4180
from genie_python import genie as g

attempts = 2000
check_freq = attempts/10

print("Starting crash test of JASCO PU-4180:")
for i in range(attempts):
    g.set_pv("JSCO4180_01:_CRASH", 1, is_local=True)
    if i%check_freq == 0:
        print("Current iteration: {0}".format(i))
        alarm = g.get_pv("JSCO4180_01:COMP:A.STAT", is_local=True)
        print("Alarm status: {alarm}".format(alarm=alarm))
        if alarm == "TIMEOUT":
            print("Record timeout - Device most likely crashed at iteration: {0}".format(i))
            break
else:
    print("Script finished: Pump was not crashed")
