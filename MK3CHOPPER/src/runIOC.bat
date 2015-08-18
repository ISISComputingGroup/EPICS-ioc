@echo OFF
set MYDIRCHOP=%~dp0

call %MYDIRCHOP%..\..\..\..\config_env_base.bat

REM get location of pvdump.dll added to PATH
call %EPICS_KIT_ROOT%support\pvdump\iocBoot\iocpvdumpTest\dllPath.bat

%HIDEWINDOW% h

%MYDIRCHOP%..\..\bin\%EPICS_HOST_ARCH%\Mk3Chopper.exe %*
