Dip switches

up = on, down = off

SW1-4 are controller adderss, all up for address = 1
SW5-6 baud rate 

baud     SW5 SW6
9600     on  on
19200    on off
38400   off   on
115200   off off

8bit, no parity

SW7 and SW8 should be off,off

I needed a NULL modem when connected from my PC, not needed from MOXA I believe

# MRES and ERES are 1 / 512 = .001953195 for the M 660 stage

The first thing you need to do is HOME the device

