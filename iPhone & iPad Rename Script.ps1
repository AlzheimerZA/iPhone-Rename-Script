# Ensure you have the MSGraph API module installed and authenticated
# Install using Install-Module Microsoft.Graph -Scope CurrentUser

#Importing required modules
Import-Module -Name Microsoft.Graph.DeviceManagement
Import-Module -Name Microsoft.Graph.Beta.DeviceManagement.Actions -Force
Import-Module -Name Microsoft.Graph.Authentication -force

# Connect to Microsoft Graph API
Connect-MgGraph -Scopes "DeviceManagementManagedDevices.ReadWrite.All", "User.Read.All" -NoWelcome

# Get all Intune managed devices with iOS and that is Supervised
$devices = Get-MgDeviceManagementManagedDevice -Filter "(contains(operatingsystem, 'iOS')%20and%20isSupervised eq true)"

foreach ($device in $devices) {
    # Get the associated user's Display Name
    $user = $Device.userDisplayName
    
    # Get the device model
    $model = $Device.model

    # Construct the new device name
    $newDeviceName = "$user's $model"

    # Check the Device name and only rename if the name is not correct.
    if ($device.deviceName -ne $newDeviceName)
{
    # Rename the device
    # Hash out the below line if you want to check affected devices befor renaming
    Set-MgBetaDeviceManagementManagedDeviceName -ManagedDeviceId $Device.Id -DeviceName $newDeviceName

    Write-Host "Renamed device ID $($device.devicename) to $newDeviceName" -ForegroundColor Green

} Else {

    Write-Host "No Devices Renamed." -ForegroundColor red

}
}

# Pause the script before disconnecting from Graph API
Pause

# Disconnect from Microsoft Graph API
Disconnect-MgGraph