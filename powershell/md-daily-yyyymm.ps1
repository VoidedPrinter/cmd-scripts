# PURPOSE
# For Organizing Daily Notes files of "yyyy-mm-dd.md" into folders of "yyyy-mm"

##############################################
# USER Set Up
# Replace USERNAME with your User name: C:\Users\USERNAME\Documents\Notes
$FullPath = "C:\\Users\\USERNAME\\Documents\\Notes";

##############################################
# Script Set Up
$FilesMoved = 0;
$currentDirectory = Get-Location

Write-Output "/==================================================\";
Write-Output "Cleaning Up Daily Notes...";
try {
    if ($($currentDirectory.Path) -notmatch $FullPath) { 
        Write-Output "  Not In Correct Directory";
        Write-Output "    Current Directory: $(Get-Location)";
        Write-Output "      Changing Directory...";
        Set-Location -Path $FullPath
        Write-Output "    Current Directory: $(Get-Location)";
    } else {
        Write-Output "    In Correct Directory: $(Get-Location)";
    }
}
catch {
    Write-Host (" !! Cannot change directories! Exiting Script.") -ForegroundColor Red -BackgroundColor Black;
    Write-Host $_
}

Write-Output "";
Write-Output "  Preparing to clean up Daily Notes";

$CurrLocation = Get-Location;

# Organize the files
$files = Get-ChildItem -file;
ForEach ($file in $files) {

    ## .md files only
    $extn = [IO.Path]::GetExtension($file)
    if ($extn -eq ".md" ){
        
        $folder = $file.Name.Substring(0,7);

        if (-not(Test-Path -path $folder)) {
            # Folder doesn't exists, create the folder
            Write-Output "    Creating New Directory: $folder";
            New-Item -Path $folder -ItemType Directory
        }

        $DestPath = Join-Path -Path $CurrLocation -ChildPath $folder;

        Write-Output "    Moving $file to $DestPath...";
        Move-Item $file.FullName $DestPath;

        $FilesMoved++;
    }
}
Write-Output "";

Write-Output "  Finished moving $FilesMoved file(s).";
Write-Output "\==================================================/";
