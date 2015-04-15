###########################################################
# .FILE		: CBM_Test_Path
# .AUTHOR  	: A. Cassidy 
# .DATE    	: 2015-04-10 
# .EDIT    	: 
# .FILE_ID	: PSTP0410
# .COMMENT 	: Test CBM Paths
# .INPUT	: NONE
# .OUTPUT	: LRMM_script.log == Log of script processes
#			  	
#           
# .VERSION : 0.1
###########################################################
# 
# .CHANGELOG
# Version 1.0: 2015-04-10 First version
# 
# .INSTRUCTIONS FOR USE
# Called from cbm_test_path.bat
#
# 
#----------------------------------------------------------
#STATIC VARIABLES
#----------------------------------------------------------
Write-Host "USER: $env:USERNAME" -foregroundcolor Yellow
Write-Host "COMPUTER: $env:COMPUTERNAME" -foregroundcolor Yellow
Write-Host "`r`nLOG: $($env:HOMEPATH)\CBM_TEST_PATH_LOG.TXT" -foregroundcolor Yellow

Write-Host "`r`nScript will now check if FY1 models are in correct folder" -foregroundcolor Yellow

Start-Sleep 2

$fy1_model_paths_file = "S:\TEST AREA\ac00418\final.txt"
$model_paths = gc -Path $fy1_model_paths_file

$old_back = $host.UI.RawUI.BackgroundColor