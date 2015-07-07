@echo off
call msbuild.exe /p:Configuration=Debug;Platform=x86 /t:clean ExperimentDataApplication.sln
call msbuild.exe /p:Configuration=Release;Platform=x86 /t:clean ExperimentDataApplication.sln
