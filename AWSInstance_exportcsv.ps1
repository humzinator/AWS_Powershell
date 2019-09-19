Set-AWSCredential -ProfileName -ProfileName

$ec2_instances = New-Object System.Collections.Generic.List[System.Object]
$props = @{
    instanceID = ''
    Name = ''
    SecurityGroups = ''
    application = ''
    privateIP = ''
}
$application = read-host “Enter Application code”
$environment = read-host "Enter Environment name"
(Get-Ec2Instance  -filter @{name='tag:application'; values=$application},@{name='tag:environment'; values=$environment} -region us-east-1).Instances | foreach {
    $InstanceData = New-Object psobject -Property $props
    $InstanceDetails = (Get-EC2Tag -region us-east-1 -Filter @{ Name="resource-id";Values=$_.InstanceId})
    $InstanceData.InstanceID = $_.InstanceID
    $instanceData.SecurityGroups =  ($_.SecurityGroups.GroupName  -join ',')
    $InstanceData.name = ((($InstanceDetails |  ? { $_.key -eq "Name" }).value) -join ',')
    $InstanceData.application = (($InstanceDetails |  ? { $_.key -eq "application" }).value -join ',')
    $InstanceData.privateIP = $_.PrivateIpAddress
    $ec2_instances.add($InstanceData)
}

Write-Output "Printing EC2 isntances...."
$ec2_instances | format-table
$ec2_instances | Export-CSV $env:USERPROFILE\Desktop\EC2-SG_InstancesExport.csv