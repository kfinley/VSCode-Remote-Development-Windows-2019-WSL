eventcreate /T INFORMATION /L APPLICATION /ID 100 /SO Startup /D "Starting wsl ssh service..."

wsl -u ubuntu -e sh -c "sudo /etc/init.d/ssh start" >> %TEMP%\ssh.out

set /p output= < %TEMP%\ssh.out 
del %TEMP%/ssh.out

eventcreate /T INFORMATION /L APPLICATION /ID 101 /SO Startup /D " %output% "