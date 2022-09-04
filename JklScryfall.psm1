<# Metadata
  CreatedBy : Jackson Brumbaugh
  CreatedOn : 2022-09-03
  Version : 20220903
#>

$ModuleHome = $PSScriptRoot

$ModuleDirs = @(
  @{ Export = $false ; Name = "HelperCmds"   }
  @{ Export = $true  ; Name = "MainCmds"     }
  @{ Export = $true  ; Name = "UnderDevCmds" }
)

$DirsToLoad = $ModuleDirs.Name
$DirsToExport = $ModuleDirs.where{ $_.Export -eq $true }.Name

foreach ( $Dir in $DirsToLoad ) {
  $ExportCmds = if ( $Dir -in $DirsToExport ) {
    $true
  } else {
    $false
  }

  $FullPath = Join-Path $ModuleHome $Dir
  if ( Test-Path $FullPath ) {
    $Scripts = Get-ChildItem $FullPath\*ps1

    foreach ( $Script in $Scripts ) {
      . $Script.FullName

      if ( $ExportCmds ) {
        Export-ModuleMember -Function $Script.BaseName
      }

    }
  } else {
    Write-Warning "Failed to locate the $Dir directory in the JklScryfall PowerShell module"
  }

} # End block:foreach Dir in DirsToLoad
