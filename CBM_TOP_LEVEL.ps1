###########################################################
# .FILE		: CBM_Top_Level
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
#
#
###########################################################



# Inputs to script
Param (
    [Parameter(Position=0, mandatory=$false)]
    [Alias("debug_switch")]
    [System.String]
    $debug_sw)






begin 
{


#----------------------------------------------------------
# STATIC VARIABLES
#----------------------------------------------------------
# 
$LOCAL_TEST = "C:\Users\ac00418" 
$dummy_run = 0

if ( $debug_sw )
{
    write-host "IN STATIC"
}

function get_cbm_settings
{
    Param (
        [Parameter(Position=0, mandatory=$true)]
	    [Alias("location")]
	    [System.String]
	    $run_environment)

$CONSTANT_DATA = New-Object psobject
if (Test-Path $run_environment)
{ # Can access network drives
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name USERPATH -Value "C:\Users\ac00418\"
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name MODEL_LIST -Value "C:\Users\ac00418\Desktop\synergee_scripts\CBM\model_data\sgn_network_models.csv"

    #----------------------------------------------------------
    # REPORTING VARIABLES
    #----------------------------------------------------------
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name CBM_SETTINGS_FILE -Value "\settings\cmb_settings.ini"
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name CBM_LOG -Value "\logs\cbm_creation_log.txt"
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name CBM_OUTPUT -Value "\logs\cbm_models_output.csv"
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name VALIDATED_LIST -Value "\cbm_validated_list.txt"
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name INVALIDATED_LIST -Value "\cbm_invalidated_list.txt"
}
else
{
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name USERPATH -Value "C:\Users\ac00418\"
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name MODEL_LIST -Value "C:\Users\ac00418\Desktop\synergee_scripts\CBM\model_data\sgn_network_models.csv"

    #----------------------------------------------------------
    # REPORTING VARIABLES
    #----------------------------------------------------------
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name CBM_SETTINGS_FILE -Value "\settings\cmb_settings.ini"
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name CBM_LOG -Value "\logs\cbm_creation_log.txt"
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name CBM_OUTPUT -Value "\logs\cbm_models_output.csv"
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name VALIDATED_LIST -Value "\cbm_validated_list.txt"
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name INVALIDATED_LIST -Value "\cbm_invalidated_list.txt"
}

if ( $debug_sw )
{
    write-host "IN CBM VARIABLES"
}

#----------------------------------------------------------
# GUI VARIABLES
#----------------------------------------------------------
$CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name width_of_console -Value 92
$CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name gui_height -Value 50
$CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name gui_width -Value 100
$CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name dash -Value "-"
$CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name double_dash -Value "$($CONSTANT_DATA.dash)$($CONSTANT_DATA.dash)"
$CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name indent -Value 5
$CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name scr_buffer_blankline -Value (" " * ($CONSTANT_DATA.width_of_console+2))
$CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name scr_buffer_box -Value ("  " +("$($CONSTANT_DATA.dash)" * $CONSTANT_DATA.width_of_console))
$CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name scr_buffer_box_nil -Value ("  " + $CONSTANT_DATA.double_dash + (" " * ($CONSTANT_DATA.width_of_console - 4)) + $CONSTANT_DATA.double_dash)
$CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name scr_buffer_indent -Value ("  " + $CONSTANT_DATA.double_dash + "  ")

return $CONSTANT_DATA
}#end get_cbm_settings



# functionality test
if ( $dummy_run )
{
    Write-Host $dummy_run
}
else
{

# Create data structure for reporting
# Find if script is run off-line or network
$CBM_SETTINGS = New-Object psobject
$CBM_SETTINGS = get_cbm_settings -location $LOCAL_TEST




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
        [Parameter(Position=1, mandatory=$false)]
	    [Alias("height")]
	    [System.String]
	    $new_height = $CBM_SETTINGS.gui_height,
        [Parameter(Position=2, mandatory=$false)]
	    [Alias("width")]
	    [System.String]
	    $new_width = $CBM_SETTINGS.gui_width)

if ( $debug_sw )
{
    write-host "IN MODIFY"
}
    
    Try
    {
        $ui_console = (Get-Host).UI.RawUI
        $old_bc = $ui_console.BackgroundColor
        $old_fc = $ui_console.ForegroundColor
        $old_title = $ui_console.WindowTitle

        # Change window to signal we're now in powershell
        $ui_console.BackgroundColor = "white"
        $ui_console.ForegroundColor = "darkred"
        $ui_console.WindowTitle = $gui_title

        # Resize window
        $buffsize = $ui_console.buffersize
		$buffsize.height = $new_height
        $buffsize.Width = $new_width
        $ui_console.BufferSize = $buffsize
        $newsize = $ui_console.windowsize
        $newsize.height = $new_height
        $newsize.width = $new_width
        $ui_console.windowsize = $newsize
        cls
    }
    Catch
    {
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
        [Parameter(Position=1, mandatory=$false)]
	    [Switch]
        $alarm)
    
    $lineRemaining = $CBM_SETTINGS.width_of_console - $column
    if ($alarm)
    {
        Write-Host -NoNewLine (" " * $lineRemaining) -ForegroundColor Yellow -BackgroundColor Black
    }
    else
    {
        Write-Host -NoNewLine (" " * $lineRemaining)
    }
        
}#end complete_line




#----------------------------------------------------------
# .function_WRITE_HEADER
#----------------------------------------------------------
function write_header
{
    Param (
        [Parameter(Position=0, mandatory=$true)]
	    [Alias("user")]
	    [System.string]
	    $user_name,
        [Parameter(Position=1, mandatory=$true)]
	    [Alias("date")]
	    [System.string]
	    $run_date,
        [Parameter(Position=2, mandatory=$true)]
	    [Alias("title")]
	    [System.string]
	    $script_title)

    Write-Host $CBM_SETTINGS.scr_buffer_blankline
	Write-Host $CBM_SETTINGS.scr_buffer_blankline
	Write-Host $CBM_SETTINGS.scr_buffer_box
	Write-Host $CBM_SETTINGS.scr_buffer_box
	Write-Host $CBM_SETTINGS.scr_buffer_box_nil

    # Title of script
    $text = $CBM_SETTINGS.scr_buffer_indent + $script_title
	$column = $text.length
	Write-Host $text -NoNewLine
	complete_line $column
	Write-Host $CBM_SETTINGS.double_dash

    # Underline the title
    $underline = ($CBM_SETTINGS.dash * ($script_title.Length))	
	$text = $CBM_SETTINGS.scr_buffer_indent + $underline
	$column = $text.length
	Write-Host $text -NoNewLine
	complete_line $column
	Write-Host $CBM_SETTINGS.double_dash	
    
    # empty lines
    Write-Host $CBM_SETTINGS.scr_buffer_box_nil

    # user
    $text = $CBM_SETTINGS.scr_buffer_indent + "USER: " + $user_name
    $column = $text.Length
	Write-Host $text -NoNewLine
	complete_line $column
	Write-Host $CBM_SETTINGS.double_dash

    # date
    $text = $CBM_SETTINGS.scr_buffer_indent + $run_date
    $column = $text.Length
	Write-Host $text -NoNewLine
	complete_line $column
	Write-Host $CBM_SETTINGS.double_dash
	Write-Host $CBM_SETTINGS.scr_buffer_box_nil
    Write-Host $CBM_SETTINGS.scr_buffer_box    
	Write-Host $CBM_SETTINGS.scr_buffer_box
	Write-Host $CBM_SETTINGS.scr_buffer_box_nil

}#end write_header




#----------------------------------------------------------
# .function_WRITE_LINE
#----------------------------------------------------------
function write_line
{
    Param (
        [Parameter(Position=0, mandatory=$true)]
	    [Alias("text")]
	    [System.string]
	    $msg,
        [Parameter(Position=1, mandatory=$false)]
	    [Alias("siren")]
	    [System.string]
	    $alarm)

    $text = $CBM_SETTINGS.scr_buffer_indent + $msg
    $column = $text.Length

    if ($alarm)
    {
        Write-Host $text -ForegroundColor Yellow -BackgroundColor Black -NoNewline 
	    complete_line $column -alarm
	    Write-Host $CBM_SETTINGS.double_dash -ForegroundColor Yellow -BackgroundColor Black
    }
    else
    {
        Write-Host $text -NoNewLine
	    complete_line $column
	    Write-Host $CBM_SETTINGS.double_dash
    }

}#end write_line



#----------------------------------------------------------
# .function_WRITE_NEW_SECTION
#----------------------------------------------------------
function write_new_section
{
    Param (
        [Parameter(Position=0, mandatory=$true)]
	    [Alias("text")]
	    [System.string]
	    $msg)

    
	Write-Host $CBM_SETTINGS.scr_buffer_box
	Write-Host $CBM_SETTINGS.scr_buffer_box_nil

    $text = $CBM_SETTINGS.scr_buffer_indent + $msg
    $column = $text.Length
	Write-Host $text -NoNewLine
	complete_line $column
	Write-Host $CBM_SETTINGS.double_dash
}#end write_line




#----------------------------------------------------------
# .function_TEST_MODEL_PATHS
#----------------------------------------------------------
function test_model_paths
{
    Param (
        [Parameter(Position=0, mandatory=$true)]
        [Alias("model_list")]
        [System.Object]
        $model_db)
    
    $valid_list = @()
    $not_valid_list = @()

    $model_list = $model_db.FY1_PATH
    $name_list = $model_db.NAME
    $region_list = $model_db.REGION

    # Assigning i will give ID, allowing models to be referenced later on.
    $i = 1
    foreach ($m in $model_list)
    {
        $msg = "`r" + $CBM_SETTINGS.scr_buffer_indent
        Write-Host $msg -NoNewline
        $msg2 = $region_list[$i]
        Write-Host $msg2 -ForegroundColor DarkBlue -NoNewline
        $msg3 = ": "
        Write-Host $msg3 -NoNewLine
        $msg4 = $name_list[$i]
        Write-Host $msg4 -ForegroundColor Blue -NoNewline
        $lineRemaining = (" " * ($CBM_SETTINGS.width_of_console - ($msg.Length + $msg2.length + $msg3.Length + $msg4.length) + 1))
        Write-host $lineRemaining -NoNewline
        Write-Host $CBM_SETTINGS.double_dash -NoNewline
        if ( Test-Path $m)
        { # true
            $valid_list += "$($m),$($i)"
        }
        else
        {
            $not_valid_list += "$($m),$($i)"
        }

        $i++
        # Start-Sleep 1
        $msg = "`r" + $CBM_SETTINGS.scr_buffer_box_nil
        Write-Host $msg -NoNewline
    }

    $n_valid = $valid_list.Length
    $n_invalid = $not_valid_list.Length

    $msg = "DONE"
    Write-host " "
    write_line -text $msg

    return $valid_list,$not_valid_list,$n_valid,$n_invalid
}# end test_model_paths

}#end else

}#end begin




process
{
    
#----------------------------------------------------------
# USER INTERFACE
#----------------------------------------------------------
$gui_title = "NETWORK PLANNING CBM 14-15 CREATION SCRIPT"
modify_gui -title $gui_title


    #----------------------------------------------------------
    # WRITE SCRIPT HEADER
    #----------------------------------------------------------
    # Write script header
    $scipt_title = "CBM CREATION SCRIPT v1.0"
    $cbm_user = $env:USERNAME
    $cbm_date = (Get-Date).ToString("yyyy-MM-dd @ hh:mm:ss")
    write_header -user $cbm_user -date $cbm_date -title $scipt_title

    #----------------------------------------------------------
    # SECTION DETAILING SETUP - WHAT GETS SAVED WHERE ETC 

    # LOAD MODEL DB
    #----------------------------------------------------------
    $msg = "Script log: " + $CBM_SETTINGS.CBM_LOG
    write_line -text $msg
    $msg = "Valid List: " + $CBM_SETTINGS.VALIDATED_LIST
    write_line -text $msg
    $msg = "   "
    write_line -text $msg
    $msg = "Loading model database"
    write_line -text $msg

    Try 
    {
	    $cbm_db = import-csv $CBM_SETTINGS.MODEL_LIST
    }
    Catch
    {
        $msg = "TERMINATE: COULD NOT IMPORT MODEL DATA"
        write_line -text $msg
        break
    }

    write-host $CBM_SETTINGS.scr_buffer_box_nil
    Write-Host $CBM_SETTINGS.scr_buffer_box
    Write-Host $CBM_SETTINGS.scr_buffer_box
    write-host $CBM_SETTINGS.scr_buffer_box_nil

    #----------------------------------------------------------
    # BEGIN TESTING PATHS
    #----------------------------------------------------------
    $msg = "1. Test Model Paths"
    write_line -text $msg

    Try
    {	# FileNotFound Exception will not cause PShell failure so explicitly state
        $ErrorActionPreference = "Stop"
        $valid_list,$not_valid_list,$n_valid,$n_invalid = test_model_paths -model_list $cbm_db
        Start-Sleep 2

        $msg = $CBM_SETTINGS.scr_buffer_indent + "   Valid:" 
        write-host $msg -NoNewline
        $msg2 = " $($n_valid)"
        write-host $msg2 -ForegroundColor DarkBlue -NoNewline
        $lineRemaining = (" " * ($CBM_SETTINGS.width_of_console - ($msg.Length + $msg2.length)))
        Write-host $lineRemaining -NoNewline
        Write-Host $CBM_SETTINGS.double_dash

        $msg = $CBM_SETTINGS.scr_buffer_indent + "   Not Valid:" 
        write-host $msg -NoNewline
        $msg2 = " $($n_invalid)"
        write-host $msg2 -ForegroundColor Red -NoNewline
        $lineRemaining = (" " * ($CBM_SETTINGS.width_of_console - ($msg.Length + $msg2.length)))
        Write-host $lineRemaining -NoNewline
        Write-Host $CBM_SETTINGS.double_dash
    }
    Catch
    {
        $msg = "WARNING: UNABLE TO LOCATE MODEL LIST"
        write_line -text $msg 
    }

    Try
    {    
        $msg = "   Writing result to file"
        write_line -text $msg
        $valid_list | Out-File $CONSTANT_DATA.VALIDATED_LIST
        $not_valid_list | Out-File $CONSTANT_DATA.INVALIDATED_LIST
    }
    Catch
    {
        $msg = "WARNING: UNABLE TO WRITE TO VALID / INVALID LIST"
        write_line -text $msg
    }

}#end process

end
{
    start-sleep 5
    $bb = read-host "Continue?"
    # return console to normal    
    $ui_console = (Get-Host).UI.RawUI
    $old_bc = $ui_console.BackgroundColor
    $old_fc = $ui_console.ForegroundColor
    $old_title = $ui_console.WindowTitle

    # Change window to signal we're now in powershell
    $ui_console.BackgroundColor = "darkblue"
    $ui_console.ForegroundColor = "white"

    # title 
    $gui_title = "Powershell"
    $ui_console.WindowTitle = $gui_title
    cls
    Write-host "  Powershell script finished"
}#end end
