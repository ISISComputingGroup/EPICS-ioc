@echo OFF
set MYDIRCHOP=%~dp0

call %MYDIRCHOP%..\..\..\..\config_env_base.bat

%HIDEWINDOW% h

%MYDIRCHOP%..\..\bin\%EPICS_HOST_ARCH%\Mk3Chopper.exe %*
