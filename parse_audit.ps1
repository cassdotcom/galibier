# parse audit files

###########################################################
# .FILE		: Parse_audit
# .AUTHOR  	: A. Cassidy 
# .DATE    	: 2015-04-18 
# .EDIT    	: 
# .FILE_ID	: PSAUD0001
# .DESCRIP 	: Read and categorise synergee logs
# .INPUT	: 
# .OUTPUT	: 
#			  	
#           
# .VERSION : 0.1
###########################################################
# 
# .CHANGELOG
# Version 0.1: 2015-04-18 First version
# 
# .INSTRUCTIONS FOR USE
# Function declarations are at the end of the file.
#
#
###########################################################

begin {

param(
    ## The path to colorize
    [Parameter(Mandatory = $true)]
    $Path,

    ## The range of dates to highlight
    $HighlightRange = @(),

    ## Switch to exclude line numbers
    [Switch] $ExcludeLineNumbers
)

test

Set-StrictMode -Version Latest

## Colors to use for the different script tokens.
## To pick your own colors:
## [Enum]::GetValues($host.UI.RawUI.ForegroundColor.GetType()) |
##     Foreach-Object { Write-Host -Fore $_ "$_" }
$replacementColours = @{
    'Attribute' = 'DarkCyan'
    'Command' = 'Blue'
    'CommandArgument' = 'Magenta'
    'CommandParameter' = 'DarkBlue'
    'Comment' = 'DarkGreen'
    'GroupEnd' = 'Black'
    'GroupStart' = 'Black'
    'Keyword' = 'DarkBlue'
    'LineContinuation' = 'Black'
    'LoopLabel' = 'DarkBlue'
    'Member' = 'Black'
    'NewLine' = 'Black'
    'Number' = 'Magenta'
    'Operator' = 'DarkGray'
    'Position' = 'Black'
    'StatementSeparator' = 'Black'
    'String' = 'DarkRed'
    'Type' = 'DarkCyan'
    'Unknown' = 'Black'
    'Variable' = 'Red'
}


$highlightColor = "Red"
$highlightCharacter = ">"
$highlightWidth = 6
if($excludeLineNumbers) { $highlightWidth = 0 }

$file = (Resolve-Path $Path).Path
$content = [IO.File]::ReadAllText($file)
$parsed = [System.Management.Automation.PsParser]::Tokenize($content, [ref] $null) | Sort StartLine,StartColumn
