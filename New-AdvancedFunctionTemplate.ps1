function New-AdvancedFunctionTemplate {
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
        [Parameter(Mandatory=$true)]
        [string]$param1
    )

    BEGIN{ # do this only once

    }
    PROCESS{
        #do this for every potential pipeline input
        
    }
    END{
        #do this after all pipeline input has been processed
    }
}

New-AdvancedFunctionTemplate -param1 "temp"