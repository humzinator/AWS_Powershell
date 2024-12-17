Import-Module AWSPowershell
Set-AWSCredential -ProfileName ProfileName

$InstanceID = (Get-EC2Instance -Filter @(@{name='tag:Name'; values="UIX*"})).Instances.InstanceId

$tag = New-Object Amazon.EC2.Model.Tag
$tag.Key = "Scheduler"
$tag.Value = "office-hours"

$InstanceID | foreach{ 
    New-EC2Tag -Resource $_ -Tag $tag 
    Write-Output "Updated tag for $_"
}
$InstanceID.Count
