###########################################################
# .FILE		: CBM_create
# .AUTHOR  	: A. Cassidy 
# .DATE    	: 2015-04-10 
# .EDIT    	: 
# .FILE_ID	: PSCB0410
# .COMMENT 	: Top Level CBM Script
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
#
# 
#----------------------------------------------------------
#STATIC VARIABLES
#----------------------------------------------------------
$CBM_SETTINGS_FILE = "\settings\cmb_settings.ini"
$CBM_LOG = "\logs\cbm_creation_log.txt"
$CBM_OUTPUT = "\logs\cbm_models_output.csv"

# Find list of FY1 models
"SCRIPT STARTED" | Out-File $CBM_LOG

Try
{
	# FileNotFound Exception will not cause PShell failure so explicitly state
    $ErrorActionPreference = "Stop"
    # Get settings content - there is some cleverness here to cope with ini format ( [ModelName] etc..)
    Get-Content $CBM_SETTINGS_FILE | foreach-object -begin {$h=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } }
    # Does data exist?
    if ($?){ } # continue
    else { throw $error[0].exception}
}
Catch
{
	"[ERROR]`t`tSettings file could not be loaded. Script will exit" | Out-File $CBM_LOG
	"[ERROR]`t`t$($CBM_SETTINGS_FILE)" | Out-File $CBM_LOG
	#Exit 1
}