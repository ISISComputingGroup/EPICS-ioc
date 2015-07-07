@echo OFF
set MYDIREDB=%~dp0

call %MYDIREDB%..\..\..\..\config_env_base.bat

REM get location of pvdump.dll added to PATH
call %EPICS_KIT_ROOT%support\pvdump\iocBoot\iocpvdumpTest\dllPath.bat

%HIDEWINDOW% h

%MYDIREDB%\ExperimentDataApplication\bin\Release\ExperimentDataApplication.exe %*
