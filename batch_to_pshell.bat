@echo off
echo Run two PShell scripts
@powershell -ExecutionPolicy Bypass -file C:\galibier\include_funcs.ps1
@powershell invoke-expression "write-a-story"
echo Script finished
@pause