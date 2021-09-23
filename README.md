# .NET Framework Development using VSCode and remote development over SSH to Windows 2019 Server

This is a quick & dirty guide for setting up .NET Framework Development using VSCode (on MacOS) using remote development over SSH on Windows 2019 Server.

Formatting and more details to come.

## Under PowerShell
```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

# Install Ubuntu

Run `ubuntu2004.ps1`

When asked to configure user use `ubuntu` as the user.

## Under WSL Shell
### Install ssh under wsl shell

```
sudo apt install ssh

sudo ssh-keygen -A

sudo mkdir -p /run/sshd
```

### Configure ssh
```
sudo visudo

#Add at end of 'Allow members...' section
%sudo ALL=NOPASSWD: /etc/init.d/ssh

#edit sshd_config
sudo pico /etc/ssh/sshd_config

PubkeyAuthentication yes
PasswordAuthentication yes # for testing..
AllowAgentForwarding yes
```

### Configure WSL path
Update ssh user `.bashrc` file and add:
```
export PATH="$PATH:/mnt/c/windows/system32:/mnt/c/Program Files (x86)/nuget:/mnt/c/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/MSBuild/Current/Bin
```
## In Windows Command Shell

### Create Startup Task

Copy `start-ssh.bat` somewhere that is system accessable such as the GPO local machine scripts folder: `C:\Windows\System32\GroupPolicy\Machine\Scripts\Startup\`.

Run the following command to create a startup task (%PATH% is the location of the `start-ssh.bat` file) :

`schtasks /create /sc ONSTART /tn "Start WSL ssh" /tr %PATH%\start-ssh.bat`

Example:
`schtasks /create /sc ONSTART /tn "Start WSL ssh" /tr C:\Windows\System32\GroupPolicy\Machine\Scripts\Startup\start-ssh.bat`

Edit the new task to 'Run whether user is logged on or not'. This will ask you for the server's Administrator password.

## On Windows (RDP)

Disable Windows Defender using local GPO.

## On Mac

Attempt to connect to confirm ssh is working. Should prompt with password. No need to login.

`ssh -vvv ubuntu@<ec2 dns name or ip address>`

Generate new key pair
`ssh-keygen`

Copy key to server
`ssh-copy-id ubuntu@<ec2 dns name or ip address>`

Conect over to server
`ssh ubuntu@ec2 dns name or ip address>`

## Sources
Taken mostly from 3 part series https://www.designmind.com/cloud-computing/setting-up-a-remote-development-environment with additional moodifications from MS online documentation.