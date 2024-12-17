Import-Module AWSPowershell
Set-AWSCredential -ProfileName ProfileName

$Users = (Import-CSV C:\users\profile\little-dipper\MOSES_group1.csv)

$BundleID = 'wsb-xxxx'
$DirectoryID = 'd-xxxx'

$tags = @()

$first_tag = New-Object Amazon.WorkSpaces.Model.Tag 
$first_tag.Key = "Name"
$first_tag.Value = "Dev Workspace"
$tags += $first_tag

$second_tag = New-Object Amazon.WorkSpaces.Model.Tag 
$second_tag.Key = "agency"
$second_tag.Value = "development"
$tags += $second_tag

$third_tag = New-Object Amazon.WorkSpaces.Model.Tag 
$third_tag.Key = "enviorment"
$third_tag.Value = "prod"
$tags += $third_tag

$forth_tag = New-Object Amazon.WorkSpaces.Model.Tag 
$forth_tag.Key = "secretariat"
$forth_tag.Value = "sec_name"
$tags += $forth_tag



$Users | foreach {
       $DomainAccounts =  $_.DET
       $Workspace = New-WKSWorkspace -Workspace @{"bundleid" = $BundleID; "Directoryid" = $DirectoryID; "username" =  $DomainAccounts; "Workspaceproperties" = @{"RunningMode" = "AUTO_STOP"; "RunningModeAutoStopTimeoutInMinutes" = 60}; "Tags" = $Tags }
       Write-Host $DomainAccounts
       $Workspace.FailedRequests
}

