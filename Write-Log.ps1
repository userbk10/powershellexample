function Write-Log {
    <# Comment based help skeleton
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .EXAMPLE
    An example

    .PARAMETER param1
    Description of param
    
    .NOTES
    General notes
    #>
    [CmdletBinding()] #Provides access to features of cmdlets suchas verbose and debug
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string]$Message,

        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-path (Split-path $_ -parent)})]
        [string]$LogFile,

        [ValidateSet("Info","Warning","Error")]
        [string]$LogLevel = "Info"
    )

    BEGIN{ # do this only once
        write-host "Begin write-log!" -ForegroundColor Green
    }
    PROCESS{
        #do this for every pipeline input
        switch ($LogLevel)
        {
            1 {$loglevelText = "ERROR: "}
            2 {$loglevelText = "WARNING: "}
            3 {$loglevelText = "INFO: "}
            default {$loglevelText = "INFO: "}
        }
        $line = "[$(Get-Date)] " + "$($loglevelText): " + $Message
        Write-Verbose "Appending line:  `"$($line)`" to file $($logfile)"
        $line | Out-File -FilePath $LogFile -Append 
        
        
    }
    END{
        #do this after all pipeline input has been processed
        Write-Host "End write-log!" -ForegroundColor Green
    }
}
