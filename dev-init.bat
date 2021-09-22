echo
echo 'Running dev initialization script...'
echo

echo 'Installing .NET Framework 4.8 SDK'

wget https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/8494001c276a4b96804cde7829c04d7f/ndp48-x86-x64-allos-enu.exe
chmod +x ndp48-x86-x64-allos-enu.exe
./ndp48-x86-x64-allos-enu.exe /q /norestart /ChainingPackage

@REM echo 'Installing .NET Framework 4.8 SDK'

@REM curl -SL --output ndp461-devpack-kb3105179-enu.exe https://download.visualstudio.microsoft.com/download/pr/33a48e6c-c0d1-4321-946b-042b92bad691/a9a88bd451286ab9ea015ecc2208d725/ndp461-devpack-kb3105179-enu.exe
@REM ndp461-devpack-kb3105179-enu.exe /q /norestart /ChainingPackage

@REM Download the Build Tools bootstrapper.
curl -SL --output vs_buildtools.exe https://aka.ms/vs/16/release/vs_buildtools.exe

chmod +x vs_buildtools.exe

@REM Run this section from Windows cmd 
vs_buildtools.exe install --wait --quiet --norestart --installPath "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\BuildTools" --nocache  --add Microsoft.VisualStudio.Workload.MSBuildTools --add Microsoft.VisualStudio.Workload.WebBuildTools 

curl -SL --output ndp48-devpack-enu.exe https://download.visualstudio.microsoft.com/download/pr/714a99a2-db28-432e-9a39-4345ba11e73f/5108686aec021898cec3de2cc4d9fd3c/ndp48-devpack-enu.exe

ndp48-devpack-enu.exe /install /quiet /norestart

curl -SL --output nuget.exe https://dist.nuget.org/win-x86-commandline/latest/nuget.exe

mkdir -p "%ProgramFiles(x86)%/nuget/"
mv nuget.exe "%ProgramFiles(x86)%/nuget/"

@REM Cleanup
del vs_buildtools.exe