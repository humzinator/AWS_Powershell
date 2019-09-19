<# 
.SYNOPSIS 
The purpose of this script to generate and output the current status on AWS SSM agents.
The script uses the AWS Powershell commands to generate a csv file.  
 
.DESCRIPTION 
Run this script to generate output of SSM Agent Status
  
Modify this line to output CSV File into different location
$ec2_instances| Export-CSV C:\temp\SSMstatus.csv
  
#>

Import-Module AWSPowershell
Set-AWSCredential -ProfileName Account-Core

# Object Properties
$props = @{
    instanceID = ''
    name = ''
    environment = ''
    application = ''
    createdby = ''
    ssmstatus = ''
    platform = ''
    platformname = ''
    ssmagentversion = ''
    iamrole = ''
}

# Set blank list of objects
$ec2_instances = New-Object System.Collections.Generic.List[System.Object]
	
(Get-EC2Instance -Filter @{Name="instance-state-code";Value="16"}).Instances | foreach {
        # Set object
        $InstanceData = new-object psobject -Property $props

        # Get Instance ID, add to object
        $InstanceData.instanceID = ($_.InstanceID)

        # Get IAM Role - catch error caused by missing IAM role
        Try{$InstanceData.iamrole = ($_.IamInstanceProfile.Arn).Substring(43)}
        Catch{$InstanceData.iamrole = "Missing IAM Role"}
        

        # Get Instance Platform
        $InstanceData.platform = ($_.Platform)
        
        # if null, set null varible to Linux (unknown flavor of linux)
        if ($InstanceData.platform -ieq $null){  $InstanceData.platform = "Linux" } 

        # Get SSM Status, add to object
        (Get-SSMInstanceInformation -InstanceInformationFilterList @{Key="InstanceIds";ValueSet=$InstanceData.instanceID}) | foreach {
            $InstanceData.ssmstatus = $_.AssociationStatus
            $InstanceData.platformname = $_.PlatformName
            $InstanceData.ssmagentversion = $_.AgentVersion

        }


        # if null, set null varible to Error - if Status is null, the rest are null too.
        if ($InstanceData.ssmstatus  -eq [String]::Empty){
            $InstanceData.ssmstatus  = "Error"
            $InstanceData.platformname  = "Unkown"
            $InstanceData.ssmagentversion  = "Error"
        } 

        # Set Tags Query 
        $InstanceTags = (Get-EC2Tag -Filter @{ Name="resource-id";Values=$InstanceData.instanceID})

        # Set Tags, add to object
        $InstanceData.environment = ($InstanceTags |  ? { $_.key -clike "environment" }).value
        $InstanceData.application = ($InstanceTags |  ? { $_.key -clike "application" }).value
        $InstanceData.name        = ($InstanceTags |  ? { $_.key -clike "Name"        }).value
        $InstanceData.application = ($InstanceTags |  ? { $_.key -clike "application" }).value
        $InstanceData.createdby   = ($InstanceTags |  ? { $_.key -clike "createdby"     }).value

        # Output Object
        $InstanceData

        # Add objects to list of other objects
        $ec2_instances.add($InstanceData)

    }

# Print out all objects
$ec2_instances| Export-CSV C:\temp\SSMstatus.csv