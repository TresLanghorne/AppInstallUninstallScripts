<#
Name: Install-AppName.ps1
Author: Tres Langhorne
Notes: 
    This script installs the AppName client and the certmanager utility. 
#>
#This will treat every error as terminating
$ErrorActionPreference ='Stop'
Function Write-ErrorLog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false,
            HelpMessage = "Error from computer.")]
        [string]$hostname,
        [Parameter(Mandatory = $false,
            HelpMessage = "Environment that failed. (Test, Production, Course, Acceptance...)")]
        [string]$env,
        [Parameter(Mandatory = $false,
            HelpMessage = "Type of server that failed. (Application, Web, Integration...)")]
        [string]$logicalname,
        [Parameter(Mandatory = $false,
            HelpMessage = "Error message.")]
        [string]$errormsg,
        [Parameter( Mandatory = $false,
            HelpMessage = "Exception.")]
        [string]$exception,
        [Parameter(Mandatory = $false,
            HelpMessage = "Name of the script that is failing.")]
        [string]$scriptname,
        [Parameter(Mandatory = $false,
            HelpMessage = "Script fails at line number.")]
        [string]$failinglinenumber,
        [Parameter(Mandatory = $false,
            HelpMessage = "Failing line looks like.")]
        [string]$failingline,
        [Parameter(Mandatory = $false,
            HelpMessage = "Powershell command path.")]
        [string]$pscommandpath,
        [Parameter(Mandatory = $false,
            HelpMessage = "Position message.")]
        [string]$positionmsg,
        [Parameter(Mandatory = $false,
            HelpMessage = "Stack trace.")]
        [string]$stacktrace
    )
    BEGIN {
        $errorlogfile = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Install-AppName.log"
        $errorlogfolder = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs"
        if ( !( Test-Path -Path $errorlogfolder -PathType "Container" ) ) {
            Write-Verbose "Create error log folder in: $errorlogfolder"
            New-Item -Path $errorlogfolder -ItemType "Container" -ErrorAction Stop
            if ( !( Test-Path -Path $errorlogfile -PathType "Leaf" ) ) {
                Write-Verbose "Create error log file in folder $errorlogfolder with name Install-AppName.log"
                New-Item -Path $errorlogfile -ItemType "File" -ErrorAction Stop
            }
        }
    }
    PROCESS {
        Write-Verbose "Start writing to Error log file. $errorlogfile"
        $timestamp = Get-Date
        #IMPORTANT: Read just first value from collection not the whole collection.
        "   " | Out-File $errorlogfile -Append
        "************************************************************************************************************" | Out-File $errorlogfile -Append
        "Error happend at time: $timestamp on a computer: $hostname - $env - $logicalname" | Out-File $errorlogfile -Append
        "Error message: $errormsg" | Out-File $errorlogfile -Append
        "Error exception: $exception" | Out-File $errorlogfile -Append
        "Failing script: $scriptname" | Out-File $errorlogfile -Append
        "Failing at line number: $failinglinenumber" | Out-File $errorlogfile -Append
        "Failing at line: $failingline" | Out-File $errorlogfile -Append
        "Powershell command path: $pscommandpath" | Out-File $errorlogfile -Append
        "Position message: $positionmsg" | Out-File $errorlogfile -Append
        "Stack trace: $stacktrace" | Out-File $errorlogfile -Append
        "------------------------------------------------------------------------------------------------------------" | Out-File $errorlogfile -Append
        Write-Verbose "Finish writing to Error log file. $errorlogfile"
    }
    END {
    }
}
#region Execution examples
#Write-ErrorLog -hostname "Server1" -env "PROD" -logicalname "APP1" -errormsg "Error Message" -exception "HResult 0789343" -scriptname "Test.ps1" -failinglinenumber "25" -failingline "Get-Service" -pscommandpath "Command pathc." -positionmsg "Position message" -stacktrace "Stack trace" -Verbose
#endregion
# Set Functions
Function Get-TimeStamp {
    
    Return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -F (Get-Date)
    
}

# Set Log Path
#$logPath = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Install-AppName.log"



# Create Log
#New-Item -Path $logPath -ItemType File -Force
Try {
<# START #>
Write-Output "$(Get-TimeStamp) Script has started."

# Install AppName

    Write-Output "Informational: Installing the AppName client..." 
    Start-Process -File AppName.exe  -ArgumentList '/S' -Wait

    # Sleep
    Start-Sleep -Seconds 5

    # Exit
    Write-Output "Informational: Done!" 
    Exit 0

}

Catch {
    Write-Warning "Error message: $_"
        $errormsg = $_.ToString()
        $exception = $_.Exception
        $stacktrace = $_.ScriptStackTrace
        $failingline = $_.InvocationInfo.Line
        $positionmsg = $_.InvocationInfo.PositionMessage
        $pscommandpath = $_.InvocationInfo.PSCommandPath
        $failinglinenumber = $_.InvocationInfo.ScriptLineNumber
        $scriptname = $_.InvocationInfo.ScriptName
        Write-Verbose "Start writing to Error log."
        Write-ErrorLog -hostname $computer -env $env -logicalname $logicalname -errormsg $errormsg -exception $exception -scriptname $scriptname -failinglinenumber $failinglinenumber -failingline $failingline -pscommandpath $pscommandpath -positionmsg $pscommandpath -stacktrace $stacktrace 
        Write-Verbose "Finish writing to Error log."
    
}