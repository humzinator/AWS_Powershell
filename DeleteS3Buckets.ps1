Initialize-AWSDefaults -ProfileName ProfileName -Region us-east-1
Set-AWSCredentials -ProfileName ProfileName



$deletelist = 
"bucket1",
"bucket2",
"bucket3",
"bucket4"

$deletelisttotal= $deletelist.Count

For($i=0; $i -le $deletelisttotal; $i++)
{
        Write-Output $deletelist[$i]
        Get-S3Object -BucketName $deletelist[$i] | % {
          Write-Output $_.key
          Remove-S3Object -BucketName $deletelist[$i] -Key $_.Key -Force:$true
        }
        Remove-S3Bucket -BucketName $deletelist[$i] -Force
    }

(Get-S3Bucket).BucketName

