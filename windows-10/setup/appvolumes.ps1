$ErrorActionPreference = "Stop"

$webserver = "intranet.mdb-lab.com"
$url = "http://" + $webserver
$installer = "App Volumes Agent.msi"
$appVolumesServer = "nl-utc-p-aps-01.nl.mdb-lab.com"
$listConfig = "/i ""C:\$installer"" /qn REBOOT=ReallySuppress MANAGER_ADDR=$appVolumesServer MANAGER_PORT=443"

# Verify connectivity
Test-Connection $webserver -Count 1

# Get AppVolumes Agent
Invoke-WebRequest -Uri ($url + "/" + $installer) -OutFile C:\$installer

# Unblock installer
Unblock-File C:\$installer -Confirm:$false

# Install AppVolumes Agent
Try 
{
   Start-Process msiexec.exe -ArgumentList $listConfig -PassThru -Wait
}
Catch
{
   Write-Error "Failed to install the AppVolumes Agent"
   Write-Error $_.Exception
   Exit -1 
}

# Cleanup on aisle 4...
Remove-Item C:\$installer -Confirm:$false