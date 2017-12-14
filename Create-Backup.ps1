<#
.SYNOPSIS
    Create-Backup.ps1 reads in a configuration xml file and creates backups of files\folders at the given location.

.DESCRIPTION
    This script reads in
#>

param ( [Parameter(Mandatory=$true)]
        [string]$ConfigFileLocation)


function Get-BackupDestination ([string]$source, [string]$destination) {

    #Verify source path, and resolve destination location and create folder if necessary
    if(!(test-path $source)) {
        throw "Could not find file\folder located at $source"
    }
    #This is the default location the backup will be saved to if the config file specifies "default" as destinationLocation
    $defaultBackuplocation = "$env:SystemDrive\Temp\defaultbackuplocation"
    if($destination -eq "default") {
        $returnDestination = $defaultBackuplocation
    }
    else {
        $returnDestination = $destination
    }
    if(!(test-path $returnDestination )) {
        New-Item -Path $returnDestination -ItemType Directory | Out-Null # pipe it to null so this output isn't captured in the "return value"
    }
    return $returnDestination

}

function Create-Backup([string] $source, [string] $destination) {

    $timestamp = get-date -format MM-dd-yy_hhmmssms
    #Create archive of folder in destination
    if( (Get-Item $source) -is [System.IO.DirectoryInfo] ) {
       #we are copying an entire folder 
       $archiveName = [string] (Split-Path $source -leaf) + $timestamp
       Compress-Archive -Path $source\* -DestinationPath "$destination\$archiveName.zip" -CompressionLevel Fastest
    }
    else {
       #get file extention
       #create new file name with timestamp, extention + .bak <originalfilename><timestamp><ext>.bak
       $fileExtension = [System.IO.Path]::GetExtension($source)
       $fileName = [System.IO.Path]::GetFileNameWithoutExtension($source)
       $newFileName = $fileName + "_" + $timestamp + "$fileExtension.bak"
       Copy-Item -Path $source -Destination $destination\$newFileName
    }

}


#Begin script
if(Test-path $ConfigFileLocation) { 
    [xml]$configDetails = Get-Content $ConfigFileLocation
    $FileNodes = $configDetails.SelectNodes("//file")
    foreach($node in $FileNodes) {
        if($node.activeBackup -eq "True") {
           try {
               $destination = Get-BackupDestination -source $node.sourceLocation -destination $node.destinationLocation
               Create-Backup -source $node.sourceLocation -destination $destination 
           }
           catch {
                Write-Error $_
           }
       }
       else {
            Write-Warning "$($node.sourceLocation) was not copied because activeBackup was not set to True. "     
       }
    }
}

else {
    Write-Error "Could not find config file location!"
}