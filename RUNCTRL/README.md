Run control is set up using PVs of the form 

%MYPVPREFIX%CS:SB:GoodFrames:RC:HIGH
%MYPVPREFIX%CS:SB:GoodFrames:RC:LOW
%MYPVPREFIX%CS:SB:GoodFrames:RC:ENABLE

as detailed elsewhere. Alerts use a similar format but with AC
(alert control) as the prefix. The all use the same underlying
framework, but the "action" is different. For run control (RC) the
action casuses DAE to go into a waiting state. For alerts (AC)
it will send a text/email alert.

Some initial setup needs to be done to configure email alerts.  
```
caput -S %MYPVPREFIX%CS:AC:ALERTS:MOBILES:SP 12345678;64535353
caput -S %MYPVPREFIX%CS:AC:ALERTS:EMAILS:SP user1@host;user2@host
caput %MYPVPREFIX%CS:AC:ALERTS:PW:SP <set this to value on ICP access page>
caput %MYPVPREFIX%CS:AC:ALERTS:INST:SP instrumentname
caput -S %MYPVPREFIX%CS:AC:ALERTS:URL:SP http://control-svcs.isis.cclrc.ac.uk/isiscgi/sendmess.py
# if you want a delay before out of range alert
caput %MYPVPREFIX%CS:AC:OUT:DELAY 5
# if you want a delay before in range alert
caput %MYPVPREFIX%CS:AC:IN:DELAY 5
```

The above values are autosaved. Then writes of the form

```
caput %MYPVPREFIX%CS:SB:GoodFrames:AC:HIGH 100
caput %MYPVPREFIX%CS:SB:GoodFrames:AC:LOW 10
caput %MYPVPREFIX%CS:SB:GoodFrames:AC:ENABLE 1
```

would alert on GoodFrames block if outside given values