# Define the source and destination directories
$sourceDir = "E:\Gannon\Plate1SelectedFolders"  # Original folder structure
$destinationDir = "E:\Gannon\Plate1SelectedFoldersDicImages"  # Destination for the selected DIC8 images

# Ensure the destination directory exists
if (-not (Test-Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir -Force
}

# Function to recursively traverse directories using DFS and copy "_DIC8.png" files
function Traverse-And-CopyFiles {
    param (
        [string]$currentDir,  # The current directory being traversed
        [string]$destination   # Destination directory
    )

    # Get all files in the current directory matching "_DIC8.png"
    $files = Get-ChildItem -Path $currentDir -File -Filter "*_DIC8.png"

    foreach ($file in $files) {
        # Generate the new name using the folder structure
        $relativePath = $file.DirectoryName.Substring($sourceDir.Length).TrimStart('\') -replace '\\', '_'
        $newFileName = "Gannon_$($relativePath)_$($file.Name)"

        # Set the destination path for the copied file
        $destinationFilePath = Join-Path -Path $destination -ChildPath $newFileName

        # Copy the file to the destination
        Copy-Item -Path $file.FullName -Destination $destinationFilePath -Force
        Write-Host "Copied $($file.FullName) to $destinationFilePath"
    }

    # Get all subdirectories in the current directory
    $subdirectories = Get-ChildItem -Path $currentDir -Directory

    # Recurse into each subdirectory (DFS traversal)
    foreach ($subdirectory in $subdirectories) {
        Traverse-And-CopyFiles -currentDir $subdirectory.FullName -destination $destination
    }
}

# Start the DFS traversal and copying process from the root source directory
Traverse-And-CopyFiles -currentDir $sourceDir -destination $destinationDir
