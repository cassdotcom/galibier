@echo off
echo --   
echo --  
echo -- NETWORK PLANNING CBM CREATION SCRIPT 2014-2015
echo -- ----------------------------------------------
@cd C:\Users\ac00418\Documents\CBM_repo
echo --                                             
echo -- SCRIPT WILL NOW BEGIN POWERSHELL
@powershell -ExecutionPolicy Bypass .\CBM_TOP_LEVEL.ps1
rem @powershell -ExecutionPolicy Bypass .\CBM_TOP_LEVEL.ps1 $true
echo returned successfully
@pause
