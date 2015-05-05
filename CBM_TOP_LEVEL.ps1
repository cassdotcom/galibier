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
    # LOAD MODEL DB
    #----------------------------------------------------------
    $msg = "Load model DB"
    write_line -text $msg

    Try 
    {
	    $cbm_db = import-csv $CONSTANT_DATA.MODEL_LIST
    }
    Catch
    {
        $msg = "TERMINATE: COULD NOT IMPORT MODEL DATA"
        write_line -text $msg -alarm
        break
    }


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
        $msg = "   Valid: $($n_valid)"
        write_line -text $msg
        $msg = "   Not Valid: $($n_invalid)"
        write_line -text $msg
        $msg = "   Writing result to file"
        write_line -text $msg
        $valid_list | Out-File $CONSTANT_DATA.VALIDATED_LIST
        $not_valid_list | Out-File $CONSTANT_DATA.INVALIDATED_LIST
    }
    Catch
    {
        $msg = "WARNING: UNABLE TO LOCATE MODEL LIST"
        write_line -text $msg -siren True
    }


    #----------------------------------------------------------
    # TEST CBM_FOLDERS
    #----------------------------------------------------------
    $msg = "2. Test CBM Folders exist"
    write_new_section -text $msg


}#end process-





begin 
{

# Inputs to script
Param (
    [Parameter(Position=0, mandatory=$false)]
    [Alias("debug_switch")]
    [System.String]
    $dummy_run)

#----------------------------------------------------------
# STATIC VARIABLES
#----------------------------------------------------------
# 
$LOCAL_TEST = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\Scotland Networks\" 
# functionality test
if ( $dummy_run )
{
    Write-Host "DUMMY RUN"
}
else
{

# Create data structure for reporting
# Find if script is run off-line or network
$CBM_SETTINGS = New-Object psobject
$CBM_SETTINGS = get_cbm_settings -location $LOCAL_TEST

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
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name MODEL_LIST -Value "\settings\cbm_model_list.txt"

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

#----------------------------------------------------------
# GUI VARIABLES
#----------------------------------------------------------
$CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name width_of_console -Value 92
$CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name gui_height -Value 50
$CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name gui_width -Value 125
$CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name dash -Value "-"
$CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name double_dash -Value "$($CONSTANT_DATA.dash)$($CONSTANT_DATA.dash)"
$CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name indent -Value 5
$CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name scr_buffer_blankline -Value (" " * $CONSTANT_DATA.width_of_console+2)
$CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name scr_buffer_box -Value ("  " +("$($CONSTANT_DATA.dash)" * $CONSTANT_DATA.width_of_console))
$CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name scr_buffer_box_nil -Value ("  " + $CONSTANT_DATA.double_dash + (" " * ($CONSTANT_DATA.width_of_console - 4)) + $CONSTANT_DATA.double_dash)
$CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name scr_buffer_indent -Value ("  " + $CONSTANT_DATA.double_dash + "  ")

return $CONSTANT_DATA
}#end get_cbm_settings


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
	    [Alias("alarm")]
	    [switch]
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

    Write-Host $scr_buffer_blankline
	Write-Host $scr_buffer_blankline
	Write-Host $scr_buffer_box
	Write-Host $scr_buffer_box
	Write-Host $scr_buffer_box_nil

    # Title of script
    $text = $scr_buffer_indent + $script_title
	$column = $text.length
	Write-Host $text -NoNewLine
	complete_line $column
	Write-Host $double_dash

    # Underline the title
    $underline = ($dash * ($script_title.Length))	
	$text = $scr_buffer_indent + $underline
	$column = $text.length
	Write-Host $text -NoNewLine
	complete_line $column
	Write-Host $double_dash	
    
    # empty lines
    Write-Host $scr_buffer_box_nil

    # user
    $text = $scr_buffer_indent + "USER: " + $user_name
    $column = $text.Length
	Write-Host $text -NoNewLine
	complete_line $column
	Write-Host $double_dash

    # date
    $text = $scr_buffer_indent + $run_date
    $column = $text.Length
	Write-Host $text -NoNewLine
	complete_line $column
	Write-Host $double_dash
    Write-Host $scr_buffer_box_nil

    
	Write-Host $scr_buffer_box
	Write-Host $scr_buffer_box_nil    

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

    $text = $scr_buffer_indent + $msg
    $column = $text.Length

    if ($alarm)
    {
        Write-Host $text -ForegroundColor Yellow -BackgroundColor Black -NoNewline 
	    complete_line $column -alarm
	    Write-Host $double_dash -ForegroundColor Yellow -BackgroundColor Black
    }
    else
    {
        Write-Host $text -NoNewLine
	    complete_line $column
	    Write-Host $double_dash
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

    
	Write-Host $scr_buffer_box
	Write-Host $scr_buffer_box_nil

    $text = $scr_buffer_indent + $msg
    $column = $text.Length
	Write-Host $text -NoNewLine
	complete_line $column
	Write-Host $double_dash
}#end write_line




#----------------------------------------------------------
# .function_TEST_MODEL_PATHS
#----------------------------------------------------------
function test_model_paths
{
    Param (
        [Parameter(Position=0, mandatory=$true)]
        [Alias("model_list")]
        [System.string]
        $model_db)
    
    $valid_list = @()
    $not_valid_list = @()

    $model_list = $model_db.FY1_PATH

    # Assigning i will give ID, allowing models to be referenced later on.
    $i = 1
    foreach ($m in $model_list)
    {
        if ( Test-Path $m)
        { # true
            $valid_list += "$($m),$($i)"
        }
        else
        {
            $not_valid_list += "$($m),$($i)"
        }

        $i++
    }

    $n_valid = $valid_list.Length
    $n_invalid = $not_valid_list.Length

    return $valid_list,$not_valid_list,$n_valid,$n_invalid
}# end test_model_paths

}#end else

}#end begin




end
{
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
