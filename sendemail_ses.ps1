$EmailFrom = "humzaisthebest@from.com"
$EmailTo = "humza@to.com"
$Subject = "TestingEmail"
$Body = "Email was sent - here's some data"
$SMTPServer = "email-smtp.us-east-1.amazonaws.com"
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
$SMTPClient.EnableSsl = $true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential(".", "./D9mO+gM");
$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)