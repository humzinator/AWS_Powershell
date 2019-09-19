
#setup my queues
$ChangeList =  New-Object System.Collections.Generic.List[System.Object]
$Queue_ChangeList =  New-Object System.Collections.Generic.List[System.Object]

$IPSetId = '9c7ca899-0e35-4044-bfc0-aa044d0971e5'

#Get the list of IP addresses from a file
$IP_Addresses = Get-Content -Path C:\Users\hjavaid\Desktop\Fraud_IPs.txt

#for each object in the file - Build Change List
$IP_Addresses | foreach {

        #setup new IPSetUpdate object
        $IPSetUpdate =  New-Object Amazon.WAFRegional.Model.IPSetUpdate

        #we want to insert these objects in the AWS WAF
        $IPSetUpdate.Action = "Insert"

        #new object for the type of objects we're performing an action on
        $IPSetDescriptor = New-object Amazon.WAFRegional.Model.IPSetDescriptor

        #the specific type of object
        $IPSetDescriptor.Type = "IPV4"

        #the IP address from the pipeline, came from the file
        $IPSetDescriptor.Value= $_

        #combine objects into IPsetupdate
        $IPSetUpdate.IPSetDescriptor = $IPSetDescriptor

        #queue this change
        $ChangeList += $IPSetUpdate
        $nChangeList = $ChangeList.Count        
    }

Write-Output "Total Change Set Size = $nChangeList"  

$choice = ""
while ($choice -notmatch "[y|n]"){
    $choice = read-host "Do you want to continue? (Y/N)"
    }

if ($choice -eq "y"){
    #Queue and Publish Changes
    $ChangeList | foreach {
        $Queue_ChangeList.Add($_)
            do {
                if ($Queue_ChangeList.Count -ieq 500){
                    #$WAF_Change_Token = Get-WAFRChangeToken
                    #Get-WAFRChangeTokenStatus -ChangeToken $WAF_Change_Token
                    #Update WAF Regional IP set 
                    Write-Output "Submiting Changes"
                    #Update-WAFRIPSet -IPSetId $IPSetId -ChangeToken $WAF_Change_Token -Update $Queue_ChangeList
                    $Queue_ChangeList.IPSetDescriptor.Value
                    $Queue_ChangeList.Clear()
                  }
                else {
                    Write-Output "Submiting Changes"
                    #Update-WAFRIPSet -IPSetId $IPSetId -ChangeToken $WAF_Change_Token -Update $Queue_ChangeList
                    $Queue_ChangeList.IPSetDescriptor.Value
                    $Queue_ChangeList.Clear()
                  }
                $Queue_ChangeList.Count    
                }until ($Queue_ChangeList.Count -ieq $ChangeList) 
 }







    }
   
else {write-host "Done!"} 



            




#Update WAF Regional IP set 
Write-Output "Submiting Changes"
#Update-WAFRIPSet -IPSetId  9c7ca899-0e35-4044-bfc0-aa044d0971e5 -ChangeToken $WAF_Change_Token -Update $Queue_ChangeList




