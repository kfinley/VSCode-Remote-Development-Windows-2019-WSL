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

### Configure PATH environment variables

### Configure WSL
Update ssh user `.bashrc` file and add:
```
export PATH="$PATH:/mnt/c/windows/system32:/mnt/c/Program Files (x86)/nuget:/mnt/c/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/MSBuild/Current/Bin:/mnt/c/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/Common7/Tools"
```

### Configure Windows

C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin
C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7\Tools

## For VS Unit Test projects

Install Visual Studio (Full) on VM.

Add `Microsoft.VisualStudio.QualityTools.UnitTestFramework.dll` to the GAC.

```
gacutil /i "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\PublicAssemblies\Microsoft.VisualStudio.QualityTools.UnitTestFramework.dll" /f
```

## Mono

Install mono-complete on WSL

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

## Mount project folder to Windows VM and WSL - DOES NOT WORK ATM
[ THIS DOESN'T WORK ATM B/C WSL VERSION CAN'T READ APFS VOLUME ]

In VirtualBox add Machine Shared Folder to projects folder (Auto Mount, F:).

In WSL add mount.
```
sudo mkdir /mnt/f
# Open /etc/fstab
F: /mnt/f drvfs defaults 0 0
```

## Additional terminal setup (until dotfiles works for wsl)
```
sudo apt install zsh

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

```

Add `zsh` to .bashrc

## Sources
Taken mostly from 3 part series https://www.designmind.com/cloud-computing/setting-up-a-remote-development-environment with additional moodifications from MS online documentation.
