@echo off
setlocal
set "MYDIR=%~dp0"
REM set "ICPDIR=c:\development\instrumentcontrol\icp\labview modules\dae\service\x64"
REM set "ICPDIR=\\isis\inst$\Kits$\CompGroup\ICP\isisdae\x64"
set "ICPDIR=%KIT_ROOT%ICP_Binaries\isisdae\x64"

REM no longer copy DLLs for standalone isisicpint, just use DCOM
REM copying DLLs could lead to conflicts w.g. with SSL in kafka

REM echo Checking %ICPDIR% for updated DAE DLLs 
REM xcopy /i /q /d /y "%ICPDIR%\debug\*.dll" "%MYDIR%..\bin\windows-x64-debug"
REM xcopy /i /q /d /y "%ICPDIR%\debug\*.manifest" "%MYDIR%..\bin\windows-x64-debug"
REM xcopy /i /q /d /y "%ICPDIR%\debug\*.pdb" "%MYDIR%..\bin\windows-x64-debug"
REM xcopy /i /q /d /y "%ICPDIR%\release\*.dll" "%MYDIR%..\bin\windows-x64"
REM xcopy /i /q /d /y "%ICPDIR%\release\*.manifest" "%MYDIR%..\bin\windows-x64"
REM xcopy /i /q /d /y "%ICPDIR%\release\*.pdb" "%MYDIR%..\bin\windows-x64"
REM xcopy /i /q /d /y "%ICPDIR%\crt_manifest_for_dae3\*.*" "%MYDIR%..\bin\windows-x64-debug"

REM need visa64.dll, visaConfMgr.dll and visaUtilities.dll  
REM if not exist "c:\windows\system32\visa64.dll" (
REM     xcopy /i /q /d /y "%ICPDIR%\visa\*.dll" "%MYDIR%..\bin\windows-x64-debug"
REM     xcopy /i /q /d /y "%ICPDIR%\visa\*.dll" "%MYDIR%..\bin\windows-x64"
REM )
