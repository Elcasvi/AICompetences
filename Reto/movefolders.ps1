$sourceDir = "E:\Gannon\Plate1"  # Original folder structure
$destinationDir = "E:\Gannon\Plate1SelectedFolders"  # Destination for replicated structure

# Define the folders to move within each derived subfolder
$foldersToCopy = @{
    "A1" = @("02_04", "03_04", "02_03", "03_03")
    "A2" = @("02_06", "03_06", "02_05", "03_05")
    "A3" = @("03_06", "04_06", "03_05", "04_05")
    "B1" = @("02_05", "03_05", "02_04", "03_04")
    "B2" = @("01_05", "02_05", "01_04", "02_04")
    "B3" = @("02_04", "03_04", "02_03", "03_03")
}

# Function to replicate folder structure and copy files
function Replicate-StructureAndCopyFiles {
    param (
        [string]$src,
        [string]$dest,
        [hashtable]$folderMap
    )

    # Get all subdirectories in the source directory
    $subfolders = Get-ChildItem -Path $src -Directory

    foreach ($subfolder in $subfolders) {
        # Create or check the derived folder in the source
        $derivedPath = Join-Path -Path $subfolder.FullName -ChildPath "derived"

        if (-not (Test-Path $derivedPath)) {
            Write-Host "Creating 'derived' folder in source: $derivedPath"
            New-Item -ItemType Directory -Path $derivedPath -Force
        }

        # Create the derived directory in the destination
        $newDerivedPath = Join-Path -Path $dest -ChildPath $subfolder.Name
        New-Item -ItemType Directory -Path $newDerivedPath -Force

        # Create subfolders and copy specified folders
        foreach ($key in $folderMap.Keys) {
            $sourceSubfolderPath = Join-Path -Path $derivedPath -ChildPath $key
            $newSubfolderPath = Join-Path -Path $newDerivedPath -ChildPath $key

            # Create the A1, A2, A3, B1, B2, B3 subfolder in the destination
            New-Item -ItemType Directory -Path $newSubfolderPath -Force

            foreach ($subFolder in $folderMap[$key]) {
                $sourceSpecificFolderPath = Join-Path -Path $sourceSubfolderPath -ChildPath $subFolder
                $destinationSpecificFolderPath = Join-Path -Path $newSubfolderPath -ChildPath $subFolder

                # Create the specific subfolder in the destination
                New-Item -ItemType Directory -Path $destinationSpecificFolderPath -Force

                # Check if the source folder exists
                if (Test-Path $sourceSpecificFolderPath) {
                    # Copy files from the source to the destination
                    Copy-Item -Path (Join-Path -Path $sourceSpecificFolderPath -ChildPath "*") -Destination $destinationSpecificFolderPath -Recurse -Force
                    Write-Host "Copied files from $sourceSpecificFolderPath to $destinationSpecificFolderPath"
                } else {
                    Write-Host "Source folder not found: $sourceSpecificFolderPath"
                }
            }
        }
    }
}

# Call the function to replicate the structure and copy files
Replicate-StructureAndCopyFiles -src $sourceDir -dest $destinationDir -folderMap $foldersToCopy