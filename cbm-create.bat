@echo off
echo --   
echo --  
echo -- NETWORK PLANNING CBM CREATION SCRIPT 2014-2015
echo -- ----------------------------------------------
@cd "S:\TEST AREA\ac00418\CBM\rev_i"

echo --                                             
echo -- SCRIPT WILL NOW BEGIN POWERSHELL
rem powershell -ExecutionPolicy Bypass -noexit .\import_CBM_modules.ps1
@powershell -ExecutionPolicy Bypass .\cbm-create.ps1
rem @powershell -ExecutionPolicy Bypass .\CBM_TOP_LEVEL.ps1 $true
@pause
