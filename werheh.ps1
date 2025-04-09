# Define the path to the file you want to remove
$filePath = "C:\path\to\your\file"

# Check if the file exists
if (Test-Path $filePath) {
    # Remove the file
    Remove-Item $filePath
    Write-Output "File removed successfully."
} else {
    Write-Output "File does not exist."
}