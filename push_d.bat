@echo off
@powershell 'Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process'
@powershell ".\CBM_TEST_PATH.ps1"
@pause