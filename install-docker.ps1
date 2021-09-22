# install the Docker-Microsoft Package Management Provider
# Install-Module -Name DockerMsftProvider -Repository PSGallery -Force

# install Docker Engine and Docker Client
# Install-Package -Name docker -ProviderName DockerMsftProvider


# Enable Nested Virtualization
Get-VM WinContainerHost | Set-VMProcessor -ExposeVirtualizationExtensions $true

Install-Module DockerProvider


Restart-Computer –Force