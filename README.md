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

## Install Mono in WSL

```
# Not sure if these need to be done
sudo apt remove gpg
sudo apt autoremove --purge -y
sudo apt install gnupg1

# required install
sudo apt-get install software-properties-common

# Install mono
curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF' | sudo apt-key add

echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
sudo apt update

sudo apt install mono-complete
```

Add to local vscode settings
"omnisharp.useGlobalMono": "always"

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

Move `export PATH=` from .bashrc to .zshrc

## Working with .NET Framework xUnit Test projects

Install .net core 5.0
```
curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin  -c 5.0
```

## Create network between Windows VM (VirtualBox) and Host (Mac)
Follow VirtualBox instructions on http://pinter.org/archives/7719.
Make sure the network adapter that is set to NAT has port 22 open for SSH.
## Install SQL Server ODBC Drivers in WSL

curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install -y msodbcsql17
# optional: for bcp and sqlcmd
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc

## Install SQL Server ODBC Driver on macOS

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release
brew update
HOMEBREW_NO_ENV_FILTERING=1 ACCEPT_EULA=Y brew install msodbcsql17 mssql-tools
```

## Sources
https://www.coderedcorp.com/blog/using-vs-code-with-a-legacy-net-project/

https://www.designmind.com/cloud-computing/setting-up-a-remote-development-environment (3 part series)

https://blog.wildernesslabs.co/work-on-meadow-using-visual-studio-code/

https://stackoverflow.com/questions/47707095/visual-studio-code-for-net-framework

MS online documentation
https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver15#ubuntu17

https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/install-microsoft-odbc-driver-sql-server-macos?view=sql-server-ver15
