###########################################################
# .FILE		: CBM_Top_Level
# .AUTHOR  	: A. Cassidy 
# .DATE    	: 2015-04-10 
# .EDIT    	: 
# .FILE_ID	: PSCBM001
# .COMMENT 	: Top Level CBM Script
# .INPUT	: NONE
# .OUTPUT	: 
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
#
###########################################################


#----------------------------------------------------------
# STATIC VARIABLES
#----------------------------------------------------------
$global:USERPATH = "C:\Users\ac00418\"


#----------------------------------------------------------
# REPORTING VARIABLES
#----------------------------------------------------------
$CBM_SETTINGS_FILE = "\settings\cmb_settings.ini"
$CBM_LOG = "\logs\cbm_creation_log.txt"
$CBM_OUTPUT = "\logs\cbm_models_output.csv"


#----------------------------------------------------------
# USER INTERFACE
#----------------------------------------------------------
$ui_console = (Get-Host).UI.RawUI
$old_bc = $ui_console.BackgroundColor
$old_fc = $ui_console.ForegroundColor
$old_title = $ui_console.WindowTitle

$ui_console.BackgroundColor = "white"
$ui_console.ForegroundColor = "darkred"
$ui_console.WindowTitle = "CBM Model Creation v1.0 -- Setup"

$table = New-Object system.Data.DataTable "script_output"
$col1 = New-Object system.Data.DataColumn modelname,([string])


# Find list of FY1 models
$msg_out = "BEGIN SCRIPT"
set-loading -msg 

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
}#end process

begin {
function set-loading
{
param (
    [Parameter(Position=0, mandatory=$true)]
	[Alias("msg")]
	[System.String]
	$msg_out)

Write-Host $msg_out -NoNewline

$scr_buffer = @("")

for($i=0;$i -lt 30; $i++)
{
    $scr_buffer = $scr_buffer + "."
    Write-Host $scr_buffer -NoNewline
    Start-Sleep -milliseconds 50
}

Write-Host "`tDONE"
Start-Sleep 1
}



function screen_buffer
{
Get-





} #end begin


