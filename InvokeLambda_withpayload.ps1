Import-Module AWSPowershell
Set-DefaultAWSRegion -Region us-east-1
Set-AWSCredential -ProfileName Account-Core

$AccountID = (Get-STSCallerIdentity).Account

(Get-EC2Instance -Filter @{Name="instance-state-name";Value="running"}).Instances.Instanceid | Foreach {
    $lambda_playload =
@"
{"detail":{"instance-id": "$_", "account-number": "$AccountID"}}
"@
    Set-AWSCredential -ProfileName MassIT-Core
    $logR = (Invoke-LMFunction -FunctionName Update_PatchGroupTag -payload $lambda_playload -LogType Tail).LogResult

    $sDecodedString=[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($logR))
    write-host $sDecodedString
    break
}