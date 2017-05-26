@echo off
set MYDIR=%~dp0
REM set ICPDIR=c:\development\instrumentcontrol\icp\labview modules\dae\service\x64
REM set ICPDIR=\\isis\inst$\Kits$\CompGroup\ICP\isisdae\x64
REM set ICPDIR=\\olympic\babylon5\Public\Freddie\isisdae\x64
set ICPDIR=%KIT_ROOT%ICP_Binaries\isisdae\x64
echo Checking %ICPDIR% for updated DAE DLLs 
xcopy /i /q /d /y "%ICPDIR%\debug\*.dll" "%MYDIR%..\bin\windows-x64-debug"
xcopy /i /q /d /y "%ICPDIR%\debug\*.manifest" "%MYDIR%..\bin\windows-x64-debug"
xcopy /i /q /d /y "%ICPDIR%\debug\*.pdb" "%MYDIR%..\bin\windows-x64-debug"
xcopy /i /q /d /y "%ICPDIR%\release\*.dll" "%MYDIR%..\bin\windows-x64"
xcopy /i /q /d /y "%ICPDIR%\release\*.manifest" "%MYDIR%..\bin\windows-x64"
xcopy /i /q /d /y "%ICPDIR%\release\*.pdb" "%MYDIR%..\bin\windows-x64"

xcopy /i /q /d /y "%ICPDIR%\crt_manifest_for_dae3\*.*" "%MYDIR%..\bin\windows-x64-debug"

REM need visa64.dll, visaConfMgr.dll and visaUtilities.dll  
if not exist "c:\windows\system32\visa64.dll" (
    xcopy /i /q /d /y "%ICPDIR%\visa\*.dll" "%MYDIR%..\bin\windows-x64-debug"
    xcopy /i /q /d /y "%ICPDIR%\visa\*.dll" "%MYDIR%..\bin\windows-x64"
)
