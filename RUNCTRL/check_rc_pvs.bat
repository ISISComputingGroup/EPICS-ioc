@echo off
setlocal
set BLOCK=%1
if "%BLOCK%" == "" (
    @echo Please specify a block name as first argument
    exit /b 1
)
set MODE=%2
if "%MODE%" == "" (
    set MODE=RC
)
echo -- Block specific %MODE% values for %BLOCK% --
caget %MYPVPREFIX%CS:SB:%BLOCK%:%MODE%:LOW
caget %MYPVPREFIX%CS:SB:%BLOCK%:%MODE%:HIGH
caget %MYPVPREFIX%CS:SB:%BLOCK%:%MODE%:OUT:TIME
caget %MYPVPREFIX%CS:SB:%BLOCK%:%MODE%:IN:TIME
caget %MYPVPREFIX%CS:SB:%BLOCK%:%MODE%:ENABLE
caget %MYPVPREFIX%CS:SB:%BLOCK%:%MODE%:INRANGE
caget %MYPVPREFIX%CS:SB:%BLOCK%:%MODE%:_VAL_CHECK
caget %MYPVPREFIX%CS:SB:%BLOCK%:%MODE%:_SEVR_CHECK
caget %MYPVPREFIX%CS:SB:%BLOCK%:%MODE%:SOI
caget %MYPVPREFIX%CS:SB:%BLOCK%:%MODE%:_CALC

echo -- Global %MODE% values --
caget %MYPVPREFIX%CS:%MODE%:OUT:CNT
caget -S %MYPVPREFIX%CS:%MODE%:OUT:LIST
caget %MYPVPREFIX%CS:%MODE%:OUT:TIME
caget %MYPVPREFIX%CS:%MODE%:IN:TIME
