@echo off
call msbuild.exe /p:Configuration=Debug;Platform=x86 ExperimentDataApplication.sln
call msbuild.exe /p:Configuration=Release;Platform=x86 ExperimentDataApplication.sln
