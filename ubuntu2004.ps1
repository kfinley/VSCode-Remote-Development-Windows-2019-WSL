Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu.appx -UseBasicParsing

Rename-Item .\Ubuntu.appx .\Ubuntu.zip

Expand-Archive .\Ubuntu.zip .\Ubuntu

cd Ubuntu

# wslconfig /u Ubuntu-20.04

.\ubuntu2004.exe

$userenv = [System.Environment]::GetEnvironmentVariable("Path", "User")

[System.Environment]::SetEnvironmentVariable("PATH", $userenv + ";C:\Users\Administrator\Ubuntu", "User")

# open up port 22 for ssh connections
Set-NetFirewallProfile -All -Enabled True

New-NetFirewallRule -DisplayName 'WSL SSH Inbound' -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('22')

