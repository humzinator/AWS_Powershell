Initialize-AWSDefaults -ProfileName ProfileName -Region us-east-1
Set-AWSCredentials -ProfileName ProfileName 


$nextToken = $null
do
{        
    $ctevent = (Find-CTEvents -MaxResult 50 -LookupAttribute @{ AttributeKey="Username"; AttributeValue="root"} -NextToken $nextToken)
    $ctevent | foreach {
        $ctevent_sourceIPAddress = $_.CloudTrailEvent | ConvertFrom-Json  | select -expand "sourceIPAddress"
        $ctevent_UserAgent = ($_.CloudTrailEvent | ConvertFrom-Json  | select -expand "userAgent").Substring(0,17)
        $ctevent_eventName = ($_.CloudTrailEvent | ConvertFrom-Json  | select -expand "eventName")
        $ctevent_arn = ($_.CloudTrailEvent | ConvertFrom-Json  | select -expand "userIdentity") | select -expand "arn"
        Write-Output "ARN: $ctevent_arn | Source IP : $ctevent_sourceIPAddress | User Agent : $ctevent_UserAgent | Event Name : $ctevent_eventName"

    }
    $nextToken = $AWSHistory.LastServiceResponse.NextToken
} while ($nextToken -ne $null)    