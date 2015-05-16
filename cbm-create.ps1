###########################################################
# .FILE		: CBM-Create
# .AUTHOR  	: A. Cassidy 
# .DATE    	: 2015-04-10 
# .EDIT    	: 
# .FILE_ID	: PSCBM001
# .COMMENT 	: Top Level CBM Script
# .INPUT	: debug_switch: cause no execution
# .OUTPUT	: Valid & Not-Valid Model Paths
#			  	
#           
# .VERSION : 0.2
###########################################################
# 
# .CHANGELOG
# Version 0.2: 2015-04-26 Reformatted
# Version 0.1: 2015-04-10 First version
# 
# .INSTRUCTIONS FOR USE
# Function declarations are at the end of the file.
# Batch file: C:\Users\ac00418\Documents\CBM_repo\CBM_Script.bat
#
#
###########################################################
# 
# .CONTENTS
# 
#
#
###########################################################




Process {

	# SETTINGS FILE
	$SETTINGS_FILE = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\CBM\settings\cbm_pshell_settings.csv"
	# LOG FILE
	$PSHELL_LOG_FILE = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\CBM\logs\cbm_pshell_log.txt"
	# Set to "stop" to catch errors
	$ErrorActionPreference = 'Stop'
	
	
	$msg = "BEGIN SCRIPT CBM-CREATE.PS1"
	write_to_log $msg $PSHELL_LOG_FILE
	
	#----------------------------------------------------------
	# 1. IMPORT SETTINGS FILE
	#----------------------------------------------------------
	Try {
		
		$msg = "1. IMPORT SETTINGS FILE"
		write_to_log $msg $PSHELL_LOG_FILE
		
		$temp_file = get-content $SETTINGS_FILE     
		
		$msg = ".....OK"
		write_to_log $msg $PSHELL_LOG_FILE

	} Catch { 
		
		$this_err = $_
		$error_name = "1. IMPORT SETTINGS FILE"
		catch_error $this_err $error_name $PSHELL_LOG_FILE

	} # end import settings file
	
	
	
	
	#----------------------------------------------------------
	# 2. SPLIT SETTINGS
	#----------------------------------------------------------
	Try {
		
		$msg = "2. SPLIT SETTINGS"
		write_to_log $msg $PSHELL_LOG_FILE
		
		$CBM_SETTINGS = New-Object psobject

		foreach ( $m in $temp_file ) {
			$CBM_SETTINGS | Add-Member -MemberType NoteProperty -Name $m.split(",")[0] -Value $m.split(",")[1]
		}

		# CREATE THE FOLLOWING BASED ON DASH ETC
		$CBM_SETTINGS | Add-Member -MemberType NoteProperty -Name scr_buffer_blankline -Value (" " * ([int]$CBM_SETTINGS.width_of_console + [int]$CBM_SETTINGS.add_to_width_of_console))
		$CBM_SETTINGS | Add-Member -MemberType NoteProperty -Name scr_buffer_box -Value ("  " +("$($CBM_SETTINGS.dash)" * $CBM_SETTINGS.width_of_console))
		$CBM_SETTINGS | Add-Member -MemberType NoteProperty -Name scr_buffer_box_nil -Value ("  " + $CBM_SETTINGS.double_dash + (" " * ($CBM_SETTINGS.width_of_console - $CBM_SETTINGS.subtract_from_w_of_c)) + $CBM_SETTINGS.double_dash)
		$CBM_SETTINGS | Add-Member -MemberType NoteProperty -Name scr_buffer_indent -Value ("  " + $CBM_SETTINGS.double_dash + "  ")
		#USER-SPECIFIC
		$CBM_SETTINGS | Add-Member -MemberType NoteProperty -Name USERPROFILE -Value $env:USERPROFILE
		$CBM_SETTINGS | Add-Member -MemberType NoteProperty -Name CBMUSER -Value $env:USERNAME

		$msg = ".....OK"
		write_to_log $msg $PSHELL_LOG_FILE
		
	} Catch {
		
		$this_err = $_
		$error_name = "2. SPLIT SETTINGS"
		catch_error $this_err $error_name
		
	} # end split settings
	
	
	
	#----------------------------------------------------------
	# 3. MODIFY THE CONSOLE
	#----------------------------------------------------------
	
	# Change title
	Try {

		$msg = "3. MODIFY THE CONSOLE - MODIFY GUI"
		write_to_log $msg $PSHELL_LOG_FILE
		
		$gui_title = "NETWORK PLANNING CBM 14-15 CREATION SCRIPT"
		modify_gui $gui_title $CBM_SETTINGS
		
		$msg = ".....OK"
		write_to_log $msg $PSHELL_LOG_FILE

	} Catch {

		$this_err = $_
		$error_name = "3. MODIFY THE CONSOLE - MODIFY GUI"
		catch_error $this_err $error_name $PSHELL_LOG_FILE

	}

	# Write header to console
	Try {
		
		$msg = "3. MODIFY THE CONSOLE - WRITE HEADER"
		write_to_log $msg $PSHELL_LOG_FILE
		
		write_header $CBM_SETTINGS $gui_title
		
		$msg = ".....OK"
		write_to_log $msg $PSHELL_LOG_FILE

	} Catch {
		
		$this_err = $_
		$error_name = "WRITE HEADER"
		catch_error $this_err $error_name $PSHELL_LOG_FILE

	}
	

	
	#----------------------------------------------------------
	# 3. IMPORT MODEL LIST
	#----------------------------------------------------------
	Try {

		$msg = "IMPORT MODEL LIST"
		write_to_log $msg $PSHELL_LOG_FILE
		
		write_line $msg $CBM_SETTINGS

		$fy1_models = Import-Csv $CBM_SETTINGS.MODEL_LIST
		
		$msg = ".....OK"
		write_to_log $msg $PSHELL_LOG_FILE

	} Catch { 
		
		$this_err = $_
		$error_name = "3. IMPORT MODEL LIST"
		catch_error $this_err $error_name $PSHELL_LOG_FILE

	} # end import model list
	
	
	#----------------------------------------------------------
	# 4. TEST FY1 PATH  
	#----------------------------------------------------------
	$msg = "TEST FY1 PATH"
	write_to_log $msg $PSHELL_LOG_FILE
	
	write_line $msg $CBM_SETTINGS

	foreach ( $model in $fy1_models ) {
		Try {
		
			$net_name = $model.NAME
			$region = $model.REGION
			write_model_name $CBM_SETTINGS $net_name $region
			
			if ( Test-Path $model.FY1_PATH ) {
				$model.FY1_VALID = "YES"
			}

		} Catch { 
		
			$this_err = $_
			$error_name = "TEST PATH: FY1"
			catch_error $this_err $error_name

		}
	} # END TEST FY1 PATH
}




Begin {

#----------------------------------------------------------
# .function_GET-TIMESTAMP
#----------------------------------------------------------
function Get-TimeStamp
{
    Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
}





#----------------------------------------------------------
# .function_CATCH_ERROR
#----------------------------------------------------------
function catch_error
{
    Param(
        [Parameter(Position=0,Mandatory=$true)]
        $err,
        [Parameter(Position=1,Mandatory=$true)]
        $error_name,
		[Parameter(Position=2,Mandatory=$true)]
		$PSHELL_LOG_FILE)

    Write-Host @"
    
     $('-' * 50)
     -- SCRIPT PROCESSING CANCELLED
     $('-' * 50)
    
     Error in $($error_name)
    
     $('-' * 50)
     -- Error information
     $('-' * 50)
    
     Line Number: $($err.InvocationInfo.ScriptLineNumber)
     Offset: $($err.InvocationInfo.OffsetInLine)
     Command: $($err.InvocationInfo.MyCommand)
     Line: $($err.InvocationInfo.Line.Trim())
     Error Details: $($err)
    
"@ -ForegroundColor Red -BackgroundColor White


    write_to_log "$('-' * 50)" $PSHELL_LOG_FILE
    write_to_log " -- SCRIPT PROCESSING CANCELLED" $PSHELL_LOG_FILE
    write_to_log " $('-' * 50)" $PSHELL_LOG_FILE
    write_to_log "" $PSHELL_LOG_FILE
    write_to_log " Error in $($error_name)" $PSHELL_LOG_FILE
    write_to_log "" $PSHELL_LOG_FILE
    write_to_log "$('-' * 50)" $PSHELL_LOG_FILE
    write_to_log " -- Error information" $PSHELL_LOG_FILE
    write_to_log " $('-' * 50)" $PSHELL_LOG_FILE
    write_to_log "" $PSHELL_LOG_FILE
    write_to_log " Line Number: $($err.InvocationInfo.ScriptLineNumber)" $PSHELL_LOG_FILE
    write_to_log " Offset: $($err.InvocationInfo.OffsetInLine)" $PSHELL_LOG_FILE
    write_to_log " Command: $($err.InvocationInfo.MyCommand)" $PSHELL_LOG_FILE
    write_to_log " Line: $($err.InvocationInfo.Line.Trim())" $PSHELL_LOG_FILE
    write_to_log " Error Details: $($err)" $PSHELL_LOG_FILE
    break
}






#----------------------------------------------------------
# .function_WRITE_TO_LOG
#----------------------------------------------------------
function write_to_log
{
	Param (
		[Parameter(Position=0, Mandatory=$true)]
		[System.String]
		$msg_raw,
		[Parameter(Position=1, Mandatory=$true)]
		[System.String]
		$PSHELL_LOG_FILE)
	
	Try {
	
		$msg = Get-TimeStamp + $msg_raw
		$msg | Out-File $PSHELL_LOG_FILE
		
	} Catch {
		
		$this_err = $_
		$error_name = "CANNOT WRITE TO LOG"
		catch_error $this_err $error_name $PSHELL_LOG_FILE
		
	}
}





#----------------------------------------------------------
# .function_MODIFY_GUI
#----------------------------------------------------------
function modify_gui
{
    Param (
        [Parameter(Position=0, mandatory=$true)]
	    [Alias("title")]
	    [System.String]
	    $gui_title,
        [Parameter(Position=1, Mandatory=$true)]
        [System.Object]
        $CBM_SETTINGS)
    
    Try
    {
        $ui_console = (Get-Host).UI.RawUI
        $old_bc = $ui_console.BackgroundColor
        $old_fc = $ui_console.ForegroundColor
        $old_title = $ui_console.WindowTitle

        # Change window to signal we're now in powershell
        $ui_console.BackgroundColor = $CBM_SETTINGS.console_background
        $ui_console.ForegroundColor = $CBM_SETTINGS.console_foreground
        $ui_console.WindowTitle = $gui_title

        # Resize window
        $buffsize = $ui_console.BufferSize
		$buffsize.height = $CBM_SETTINGS.gui_height
        $buffsize.Width = $CBM_SETTINGS.gui_width
        $ui_console.BufferSize = $buffsize
        $newsize = $ui_console.windowsize
        $newsize.height = $CBM_SETTINGS.gui_height
        $newsize.width = $CBM_SETTINGS.gui_width
        $ui_console.windowsize = $newsize
        cls
    }
    Catch
    {
        $this_err = $_
        $error_name = "UI CONSOLE MODIFY"
        catch_error $this_err $error_name
        Write-Warning "UNABLE TO MODIFY CONSOLE"
    }

}#end modify_gui







#----------------------------------------------------------
# .function_COMPLETE_LINE
#----------------------------------------------------------
function complete_line
{
    Param (
        [Parameter(Position=0, mandatory=$true)]
	    [Alias("col")]
	    [System.int32]
	    $column,
        [Parameter(Position=1, mandatory=$true)]
	    [System.Object]
        $CBM_SETTINGS)
    
    $lineRemaining = $CBM_SETTINGS.width_of_console - $column
    Write-Host -NoNewLine (" " * $lineRemaining)
        
}#end complete_line






#----------------------------------------------------------
# .function_UNDERLINE_TITLE
#----------------------------------------------------------
function underline_title
{
    Param(
        [Parameter(Position=0, mandatory=$true)]
	    [Alias("underline_this")]
	    [System.string]
	    $this_title,
        [Parameter(Position=1, mandatory=$true)]
	    [System.Object]
        $CBM_SETTINGS)

    # Underline the title
    $underline = ($CBM_SETTINGS.dash * ($this_title.Length))	
	$text = $CBM_SETTINGS.scr_buffer_indent + $underline
	$column = $text.length
	Write-Host $text -NoNewLine
	complete_line $column $CBM_SETTINGS
	Write-Host $CBM_SETTINGS.double_dash	

}#end underline_title








#----------------------------------------------------------
# .function_WRITE_HEADER
#----------------------------------------------------------
function write_header
{
    Param (
        [Parameter(Position=0, mandatory=$true)]
	    [Alias("user")]
	    [System.Object]
	    $CBM_SETTINGS,
        [Parameter(Position=1, mandatory=$true)]
	    [Alias("title")]
	    [System.string]
	    $script_title)

    # The following lines create a box
    Write-Host $CBM_SETTINGS.scr_buffer_blankline
	Write-Host $CBM_SETTINGS.scr_buffer_blankline
	Write-Host $CBM_SETTINGS.scr_buffer_box
	Write-Host $CBM_SETTINGS.scr_buffer_box
	Write-Host $CBM_SETTINGS.scr_buffer_box_nil

    # Title of script
    $text = $CBM_SETTINGS.scr_buffer_indent + $script_title
	$column = $text.length
	Write-Host $text -NoNewLine
	complete_line $column $CBM_SETTINGS
	Write-Host $CBM_SETTINGS.double_dash

    # Underline the title
    underline_title	-underline_this $script_title $CBM_SETTINGS
    
    # empty lines
    Write-Host $CBM_SETTINGS.scr_buffer_box_nil

    # user
    $text = $CBM_SETTINGS.scr_buffer_indent + "USER: " + $CBM_SETTINGS.CBMUSER
    $column = $text.Length
	Write-Host $text -NoNewLine
	complete_line $column $CBM_SETTINGS
	Write-Host $CBM_SETTINGS.double_dash

    # date
    $text = $CBM_SETTINGS.scr_buffer_indent + $run_date
    $column = $text.Length
	Write-Host $text -NoNewLine
	complete_line $column $CBM_SETTINGS
	Write-Host $CBM_SETTINGS.double_dash
	Write-Host $CBM_SETTINGS.scr_buffer_box_nil
    Write-Host $CBM_SETTINGS.scr_buffer_box    
	Write-Host $CBM_SETTINGS.scr_buffer_box
	Write-Host $CBM_SETTINGS.scr_buffer_box_nil

}#end write_header



function write_model_name
{
   Param (
	[Parameter(Position=0, mandatory=$true)]
	[Alias("user")]
	[System.Object]
	$CBM_SETTINGS,
	[Parameter(Position=1, mandatory=$true)]
	[System.string]
	$name,
	[Parameter(Position=2, mandatory=$true)]
	[System.string]
	$region)

	$msg = "`r" + $CBM_SETTINGS.scr_buffer_indent
	Write-Host $msg -NoNewline
	$msg2 = $region
	Write-Host $msg2 -ForegroundColor $CBM_SETTINGS.foreground_region -NoNewline
	$msg3 = ": "
	Write-Host $msg3 -NoNewLine
	$msg4 = $name
	Write-Host $msg4 -ForegroundColor $CBM_SETTINGS.foreground_network -NoNewline
	$lineRemaining = (" " * ($CBM_SETTINGS.width_of_console - ($msg.Length + $msg2.length + $msg3.Length + $msg4.length) + 1))
	Write-host $lineRemaining -NoNewline
	Write-Host $CBM_SETTINGS.double_dash -NoNewline

	
}






