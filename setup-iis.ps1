Install-WindowsFeature -Name Web-Server -IncludeManagementTools

@"
<html>
<head>
<title>Azure Web Server</title>
</head>
<body>
<h1>IIS Deployment Successful</h1>
<p>Deployed from ARM Template and GitHub.</p>
</body>
</html>
"@ | Set-Content C:\inetpub\wwwroot\index.html