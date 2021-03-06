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
# 
# .CONTENTS
# 
#
#
###########################################################




# Inputs to script
Param (
    [Parameter(Position=0, mandatory=$false)]
    [Alias("debug_switch")]
    [System.String]
    $debug_sw)



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
    #----------------------------------------------------------
    $msg = "Settings File: " + $SETTINGS_FILE
    write_line -text $msg
    $msg = "Script log: " + $CBM_SETTINGS.CBM_LOG
    write_line -text $msg
    $msg = "Valid List: " + $CBM_SETTINGS.VALIDATED_LIST
    write_line -text $msg


    #----------------------------------------------------------
    # LOAD MODEL DB
    #----------------------------------------------------------
    $msg = "1. Loading model database"
    graphical_new_section -section_heading $msg

    # actual load function
    $cbm_db = load_model_db

    # if it didnt work script would exit already
    $msg = "Database loaded successfully"
    write_line -text $msg

    #----------------------------------------------------------
    # BEGIN TESTING PATHS
    #----------------------------------------------------------
    $msg = "2. Test Model Paths"
    graphical_new_section -section_heading $msg

    # Call function
    Try
    {	# FileNotFound Exception will not cause PShell failure so explicitly state
        $ErrorActionPreference = "Stop"
        $valid_list,$not_valid_list,$n_valid,$n_invalid = test_model_paths -model_list $cbm_db
        Start-Sleep $CBM_SETTINGS.delay
    }
    Catch
    {
        $msg = "WARNING: UNABLE TO TEST MODEL PATHS"
        write_line -text $msg -siren
        break
    }


    # Report results
    Try
    {
        $ErrorActionPreference = "Stop"
        $msg = $CBM_SETTINGS.scr_buffer_indent + "   Valid:" 
        report_results -text $msg -numbers $n_valid

        $msg = $CBM_SETTINGS.scr_buffer_indent + "   Not Valid:" 
        report_results -text $msg -numbers $n_invalid
    }
    Catch
    {
        $msg = "WARNING: NO VALID OR INVALID DATA FOUND"
        write_line -text $msg -siren
        break
    }

    Try
    {    
        $msg = "   Writing result to file"
        write_line -text $msg
        $valid_list | Out-File $CBM_SETTINGS.VALIDATED_LIST
        $not_valid_list | Out-File $CBM_SETTINGS.INVALIDATED_LIST
    }
    Catch
    {
        $msg = "WARNING: UNABLE TO WRITE VALID / INVALID LIST TO FILE"
        write_line -text $msg -siren
    }

    #----------------------------------------------------------
    # 2a. ATTEMPT TO FIND NON VALID FY1
    #----------------------------------------------------------

    #
    #
    # DO HERE
    #
    #


    #----------------------------------------------------------
    # CHECK CBM FOLDER LOCATION
    #----------------------------------------------------------
    $msg = "3. Test CBM Folder Location"
    graphical_new_section -section_heading $msg

    # Call function
    #



    #
    # LOOK BELOW -->
    #
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # !CHANGE THIS BACK AFTER TESTING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    if ( $not_valid_list.Length -gt 0 )
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # if ( $valid_list.Length -gt 0 )!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #
    #
    #
    #
    #
    #
    {

    #
    # LOOK BELOW -->
    #
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # !CHANGE THIS BACK AFTER TESTING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            $n_cbm,$n_cbm_notvalid = test_cbm_loc -database $cbm_db -valid_list $not_valid_list
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #  $cbm_to_copy_list,$n_cbm = test_cbm_loc -database $cbm_db -valid_list $not_valid_list
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #
    #
    #
    #
    #
    #
            Start-Sleep $CBM_SETTINGS.delay


    }
    else
    {
        $msg = "THERE ARE NO VALID MODELS"
        write_line -text $msg -siren
        $msg = "THIS IS GAME OVER"
        write_line -text $msg -siren
        break
    }

    # Report Test 3. results
    Try
    {
        $ErrorActionPreference = "Stop"
        $msg = $CBM_SETTINGS.scr_buffer_indent + "   Valid:" 
        report_results -text $msg -numbers $n_valid

        $msg = $CBM_SETTINGS.scr_buffer_indent + "   Not Valid:" 
        report_results -text $msg -numbers $n_invalid
    }
    Catch
    {
        $msg = "WARNING: NO VALID OR INVALID DATA FOUND"
        write_line -text $msg -siren
        break
    }




    #----------------------------------------------------------
    # WRITE TEXT REPORT ABOUT RESULTS
    #----------------------------------------------------------

    #
    #
    # DO HERE
    #
    #
    #

}#end process



begin 
{
#----------------------------------------------------------
# STATIC VARIABLES
#----------------------------------------------------------
# 
$SETTINGS_FILE = "C:\Users\ac00418\Documents\CBM_repo\cbm_pshell_settings.ini"
$LOCAL_TEST = "C:\Users\ac00418" 
$dummy_run = 0
cls

#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
if ( $debug_sw ){write-host "IN STATIC"}
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



#----------------------------------------------------------
# .function_GET_CBM_SETTINGS
#----------------------------------------------------------
function get_cbm_settings
{
    Param (
        [Parameter(Position=0, mandatory=$true)]
	    [Alias("location")]
	    [System.String]
	    $run_environment)

    Try
    {
        $ErrorActionPreference = "Stop"
        if (Test-Path $run_environment)
        {
            Get-Content $SETTINGS_FILE | foreach-object -begin {$h=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } }
        }
        if ($?){ } # continue
        else { throw $error[0].exception}
    }# end try
    Catch
    {
        Write-Warning " "
        Write-Warning "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        Write-Warning " "
        Write-Warning "ERROR: Settings file not loaded."
        Write-Warning " "
        Write-Warning "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        return
    }

    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    if ( $debug_sw ){write-host "IN CBM VARIABLES"}
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    # Create data structure
    $CONSTANT_DATA = New-Object psobject

    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name USERPATH -Value $h.Get_Item("USERPATH")
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name MODEL_LIST -Value $h.Get_Item("MODEL_LIST")
    # REPORTING VARIABLES
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name CBM_LOG -Value $h.Get_Item("CBM_LOG")
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name CBM_OUTPUT -Value $h.Get_Item("CBM_OUTPUT")
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name VALIDATED_LIST -Value $h.Get_Item("VALIDATED_LIST")
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name INVALIDATED_LIST -Value $h.Get_Item("INVALIDATED_LIST")
    # GUI VARIABLES
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name width_of_console -Value $h.Get_Item("width_of_console")
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name gui_height -Value $h.Get_Item("gui_height")
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name gui_width -Value $h.Get_Item("gui_width")
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name dash -Value $h.Get_Item("dash")
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name indent -Value $h.Get_Item("indent")
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name add_to_width_of_console -Value $h.Get_Item("add_to_width_of_console")
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name subtract_from_w_of_c -Value $h.Get_Item("subtract_from_w_of_c")
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name console_foreground -Value $h.Get_Item("console_foreground")
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name console_background -Value $h.Get_Item("console_background")
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name warning_foreground -Value $h.Get_Item("warning_foreground")
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name warning_background -Value $h.Get_Item("warning_background")
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name foreground_region -Value $h.Get_Item("foreground_region")
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name foreground_network -Value $h.Get_Item("foreground_network")
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name foreground_invalid -Value $h.Get_Item("foreground_invalid")
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name default_foreground -Value $h.Get_Item("default_foreground")
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name default_background -Value $h.Get_Item("default_background")
    # CREATE THE FOLLOWING BASED ON DASH ETC
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name double_dash -Value "$($CONSTANT_DATA.dash)$($CONSTANT_DATA.dash)"
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name scr_buffer_blankline -Value (" " * ([int]$CONSTANT_DATA.width_of_console + [int]$CONSTANT_DATA.add_to_width_of_console))
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name scr_buffer_box -Value ("  " +("$($CONSTANT_DATA.dash)" * $CONSTANT_DATA.width_of_console))
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name scr_buffer_box_nil -Value ("  " + $CONSTANT_DATA.double_dash + (" " * ($CONSTANT_DATA.width_of_console - $CONSTANT_DATA.subtract_from_w_of_c)) + $CONSTANT_DATA.double_dash)
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name scr_buffer_indent -Value ("  " + $CONSTANT_DATA.double_dash + "  ")
    # ASSORTED CONSTANTS
    $CONSTANT_DATA | Add-Member -MemberType NoteProperty -Name delay -Value $h.Get_Item("delay")
    return $CONSTANT_DATA
}#end get_cbm_settings



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

    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    if ( $debug_sw ){write-host "IN MODIFY"}
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    
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

    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    if ( $debug_sw ){write-host "IN COMPLETE_LINE"}
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    
    $lineRemaining = $CBM_SETTINGS.width_of_console - $column
    if ($alarm)
    {
        Write-Host -NoNewLine (" " * $lineRemaining) -ForegroundColor $CBM_SETTINGS.warning_foreground -BackgroundColor $CBM_SETTINGS.warning_background
    }
    else
    {
        Write-Host -NoNewLine (" " * $lineRemaining)
    }
        
}#end complete_line


function underline_title
{
    Param(
        [Parameter(Position=0, mandatory=$true)]
	    [Alias("underline_this")]
	    [System.string]
	    $this_title)

    # Underline the title
    $underline = ($CBM_SETTINGS.dash * ($this_title.Length))	
	$text = $CBM_SETTINGS.scr_buffer_indent + $underline
	$column = $text.length
	Write-Host $text -NoNewLine
	complete_line $column
	Write-Host $CBM_SETTINGS.double_dash	

}#end underline_this

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

    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    if ( $debug_sw ){write-host "IN WRITE_HEADER"}
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
	complete_line $column
	Write-Host $CBM_SETTINGS.double_dash

    # Underline the title
    underline_title	-underline_this $script_title
    
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
	    [Switch]
	    $alarm)

    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    if ( $debug_sw ){write-host "IN WRITE_LINE"}
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    $text = $CBM_SETTINGS.scr_buffer_indent + $msg
    $column = $text.Length

    if ($alarm)
    {
        Write-Host $text -ForegroundColor $CBM_SETTINGS.warning_foreground -BackgroundColor $CBM_SETTINGS.warning_background -NoNewline 
	    complete_line $column -alarm
	    Write-Host $CBM_SETTINGS.double_dash -ForegroundColor $CBM_SETTINGS.warning_foreground -BackgroundColor $CBM_SETTINGS.warning_background
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

    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    if ( $debug_sw ){write-host "IN WRITE_NEW_SECTION"}
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        
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

    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    if ( $debug_sw ){write-host "IN TEST MODEL PATHS"}
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    
    $valid_list = @()
    $not_valid_list = @()

    $n_to_do = ($model_db.ID).Length

    for($i = 0; $i -lt $n_to_do; $i++)
    {
        $model = $model_db.FY1_PATH[$i]
        $name = $model_db.NAME[$i]
        $region = $model_db.REGION[$i]
        $id = $model_db.ID[$i]
        Write-Warning $id

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
        if ( Test-Path $model)
        { # true
            $valid_list += $id
        }
        else
        {
            $not_valid_list += $id
        }

        # Start-Sleep 1
        $msg = "`r" + $CBM_SETTINGS.scr_buffer_box_nil
        Write-Host $msg -NoNewline
    }

    $n_valid = $valid_list.Length
    Write-Host "valid = $($n_valid)"
    $n_invalid = $not_valid_list.Length
    Write-Host $n_invalid

    $msg = "DONE"
    Write-host " "
    write_line -text $msg

    return $valid_list,$not_valid_list,$n_valid,$n_invalid
}# end test_model_paths

#----------------------------------------------------------
# .function_GRAPHICAL_NEW_SECTION
#----------------------------------------------------------
function graphical_new_section
{
    Param (
        [Parameter(Position=0, mandatory=$true)]
	    [Alias("section_heading")]
	    [System.string]
	    $msg)

    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    if ( $debug_sw ){write-host "IN GRAPHICAL_NEW_SECTION"}
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    write-host $CBM_SETTINGS.scr_buffer_box_nil
    Write-Host $CBM_SETTINGS.scr_buffer_box
    Write-Host $CBM_SETTINGS.scr_buffer_box
    write-host $CBM_SETTINGS.scr_buffer_box_nil        

    $text = $CBM_SETTINGS.scr_buffer_indent + $msg
    $column = $text.Length
	Write-Host $text -NoNewLine
	complete_line $column
	Write-Host $CBM_SETTINGS.double_dash

    underline_title -underline_this $text

}#end graphical_new_section

#----------------------------------------------------------
# .function_LOAD_MODEL_DB
#----------------------------------------------------------
function load_model_db
{
    Try 
    {
	    $cbm_db = import-csv $CBM_SETTINGS.MODEL_LIST
        $bOK = $true
    }
    Catch
    {
        $msg = "TERMINATE: COULD NOT IMPORT MODEL DATA"
        write_line -text $msg -siren
        break
    }

    return $cbm_db
}

#----------------------------------------------------------
# .function_REPORT_RESULTS
#----------------------------------------------------------
function report_results
{
    Param (
        [Parameter(Position=0, mandatory=$true)]
	    [Alias("text")]
	    [System.string]
	    $msg,
        [Parameter(Position=1, mandatory=$true)]
	    [Alias("numbers")]
	    [System.Int32]
	    $n_report)


        write-host $msg -NoNewline
        $msg2 = " " + ($n_report)
        write-host $msg2 -ForegroundColor $CBM_SETTINGS.foreground_region -NoNewline
        $lineRemaining = (" " * ($CBM_SETTINGS.width_of_console - ($msg.Length + $msg2.length)))
        Write-host $lineRemaining -NoNewline
        Write-Host $CBM_SETTINGS.double_dash

}


#----------------------------------------------------------
# .function_TEST_CBM_LOC
#----------------------------------------------------------
function test_cbm_loc
{
    Param (
        [Parameter(Position=0, mandatory=$true)]
        [Alias("database")]
        [System.Object]
        $model_db,
        [Parameter(Position=1, mandatory=$true)]
        [Alias("valid_list")]
        [System.Array]
        $valid_models)


    $valid_list = @()
    $not_valid_list = @()

    $n_to_do = $valid_models.Length
    Write-Warning $n_to_do

    for($i = 0; $i -lt $n_to_do; $i++)
    {
        $j = $valid_models[$i]
        Write-Warning $j
        $cbm = $model_db.CBM_FOLDER[$j]
        $name = $model_db.NAME[$j]
        $region = $model_db.REGION[$j]
        $id = $model_db.ID[$j]
           
   
        Try
        {
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
            Write-Host $CBM_SETTINGS.double_dash
            if ( Test-Path ($cbm) )
            { # true
                $valid_list += $id
            }
            else
            {
                $not_valid_list += $id
            }
        }
        Catch
        {
        
            $msg = "WARNING: UNABLE TO TEST CBM FOLDERS"
            write_line -text $msg -siren
            $msg = $name
            write_line -text $msg -siren
            break
        }

     }
     return $valid_list,$not_valid_list

}#end test_cbm_loc






}#end begin




end
{
    start-sleep -Milliseconds 100
    $bb = read-host "Continue?"
    # return console to normal    
    $ui_console = (Get-Host).UI.RawUI
    $old_bc = $ui_console.BackgroundColor
    $old_fc = $ui_console.ForegroundColor
    $old_title = $ui_console.WindowTitle

    # Change window to signal we're now in powershell
    $ui_console.BackgroundColor = $CBM_SETTINGS.default_background
    $ui_console.ForegroundColor = $CBM_SETTINGS.default_foreground

    # title 
    $gui_title = "Powershell"
    $ui_console.WindowTitle = $gui_title
    cls
    Write-host "  Powershell script finished"
}#end end
