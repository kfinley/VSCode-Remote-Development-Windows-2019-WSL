echo off
setlocal ENABLEDELAYEDEXPANSION

echo ':::::------'
echo 'Running dev initialization script...'
echo '------:::::'

IF "%1"=="4.7.2" (
    echo 'Installing.NET Framework 4.7.2 SDK'
    curl -SL --output ndp472-kb4054530-x86-x64-allos-enu.exe https://download.visualstudio.microsoft.com/download/pr/1f5af042-d0e4-4002-9c59-9ba66bcf15f6/089f837de42708daacaae7c04b7494db/ndp472-kb4054530-x86-x64-allos-enu.exe
    ndp472-kb4054530-x86-x64-allos-enu.exe /q /norestart /ChainingPackage

    echo 'Installing .NET Framework 4.7.2 Dev Pack'
    curl -SL --output ndp472-devpack-enu.exe https://download.visualstudio.microsoft.com/download/pr/158dce74-251c-4af3-b8cc-4608621341c8/9c1e178a11f55478e2112714a3897c1a/ndp472-devpack-enu.exe
    ndp472-devpack-enu.exe /install /quiet /norestart

) ELSE (
    echo 'Installing .NET Framework 4.8 SDK'
    curl -SL --output ndp48-x86-x64-allos-enu.exe https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/8494001c276a4b96804cde7829c04d7f/ndp48-x86-x64-allos-enu.exe
    ndp48-x86-x64-allos-enu.exe /q /norestart /ChainingPackage

    echo 'Installing .NET Framework 4.8 Dev Pack'
    curl -SL --output ndp48-devpack-enu.exe https://download.visualstudio.microsoft.com/download/pr/714a99a2-db28-432e-9a39-4345ba11e73f/5108686aec021898cec3de2cc4d9fd3c/ndp48-devpack-enu.exe
    ndp48-devpack-enu.exe /install /quiet /norestart
)

echo 'Installing VS Build Tools'
curl -SL --output vs_buildtools.exe https://aka.ms/vs/16/release/vs_buildtools.exe
vs_buildtools.exe install --wait --quiet --norestart --installPath "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\BuildTools" --nocache  --add Microsoft.VisualStudio.Workload.MSBuildTools --add Microsoft.VisualStudio.Workload.WebBuildTools 

echo 'Installing nuget'
curl -SL --output nuget.exe https://dist.nuget.org/win-x86-commandline/latest/nuget.exe
mkdir -p "%PROGRAMFILES(x86)%/nuget/"
move nuget.exe "%PROGRAMFILES(x86)%/nuget/"
