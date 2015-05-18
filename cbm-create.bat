@echo off
echo --   
echo --  
echo -- NETWORK PLANNING CBM CREATION SCRIPT 2014-2015
echo -- ----------------------------------------------
REM @powershell -command "copy-item -Path 'S:\TEST AREA\ac00418\CBM\rev_i\cbm-create.ps1' -destination cbm-create.ps1"
echo --                                             
echo -- BEGIN POWERSHELL
rem powershell -ExecutionPolicy Bypass -noexit .\import_CBM_modules.ps1
@powershell -ExecutionPolicy Bypass .\cbm-create.ps1
rem @powershell -ExecutionPolicy Bypass .\CBM_TOP_LEVEL.ps1 $true
REM @powershell -command "Remove-Item cbm-create.ps1"
pause
