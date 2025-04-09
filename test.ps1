# Define variables

$sourceGroupId = "a2e47831-2eaf-4644-ba22-42e93bb74f10"  # Replace with the actual Object ID of the source group
$targetGroupId = "7e7c8524-184d-44a0-bc7b-627e70a391dd"  # Replace with the actual Object ID of the target group

# Install the Exchange Online Management module if not already installed
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber
}

# Connect to Exchange Online
Connect-ExchangeOnline

try {
    # Get members of the source group using Object ID
    $members = Get-UnifiedGroupLinks -Identity $sourceGroupId -LinkType Members

    # Check if there are members to copy
    if ($members.Count -eq 0) {
        Write-Host "No members found in the source group with Object ID: $sourceGroupId"
    } else {
        # Add members to the target group using Object ID
        foreach ($member in $members) {
            try {
                Add-UnifiedGroupLinks -Identity $targetGroupId -LinkType Members -Links $member.PrimarySmtpAddress
                Write-Host "Added $($member.PrimarySmtpAddress) to the target group with Object ID: ${targetGroupId}"
            } catch {
                Write-Host "Failed to add $($member.PrimarySmtpAddress) to the target group with Object ID: ${targetGroupId}: $_"
            }
        }
    }
} catch {
    Write-Host "An error occurred: $_"
} finally {
    # Disconnect from Exchange Online
    Disconnect-ExchangeOnline -Confirm:$false
}
