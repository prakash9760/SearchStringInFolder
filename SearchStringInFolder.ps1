<#
.SYNOPSIS
For Searching string in a directory in specific pattern files

.PARAMETER Path
1. stringToSearch
2. searchDir
3. filePattern
.EXAMPLE
.\SearchStringInFolder "testString" ".\testFolder" "*.*"
#>
Param([Parameter(Mandatory)][string]$stringToSearch,[Parameter(Mandatory)][string]$searchDir,[Parameter(Mandatory)][string]$filePattern)

#$FilesLocation = Read-Host "Please enter the location of files to search string into"
$FilesLocation = $searchDir
$SubStringToSearch = $stringToSearch
$FilePattern = $filePattern

$Files = dir -Path $FilesLocation -Filter $FilePattern -Recurse | %{$_.FullName}
$Result = ".\Result.txt"
if(test-Path $Result)
{
	Remove-Item $Result -Force	
}
New-Item $Result -ItemType File -Force

foreach($value in $Files)
{
    Write-Host "Searching string in " $value
    #$SEL = Select-String -Path  $value -Pattern dotnet
    $SEL = Get-Content $value | %{$_ -match $SubStringToSearch}
    
    foreach($Result in $SEL)
    {
        if ($Result -eq $true)
        {
			$msg = "Contains string in " + $value
			$msg | Out-File $Result -Append
            Write-Host $msg -ForegroundColor Green
            break
        }
    }
}