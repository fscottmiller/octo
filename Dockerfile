FROM jenkins/inbound-agent:windowsservercore-1809

ARG OCTO_TOOLS_VERSION=4.31.1
ARG user=jenkins

# use cmd to set path
SHELL ["cmd", "/S", "/C"] 
# Update system path
USER ContainerAdministrator
RUN setx path "%path%;C:\Program Files\octo;C:\Program Files\dotnet"
# RUN $ENV:PATH="$ENV:PATH;C:\Program Files\octo;C:\Program Files\dotnet"
USER ${user}

# use powershell for rest of build
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV OCTO_TOOLS_DOWNLOAD_URL https://download.octopusdeploy.com/octopus-tools/$OCTO_TOOLS_VERSION/OctopusTools.$OCTO_TOOLS_VERSION.portable.zip

# Retrieve Octopus CLI
RUN Invoke-WebRequest $Env:OCTO_TOOLS_DOWNLOAD_URL -OutFile OctopusTools.zip; \
	Expand-Archive OctopusTools.zip -DestinationPath octo; \
	Remove-Item -Force OctopusTools.zip; \
	mkdir src |Out-Null
	
# Retrieve .NET Core Runtime
ENV DOTNET_VERSION 2.1.21

RUN Invoke-WebRequest -OutFile dotnet.zip https://dotnetcli.azureedge.net/dotnet/Runtime/$Env:DOTNET_VERSION/dotnet-runtime-$Env:DOTNET_VERSION-win-x64.zip; `
    $dotnet_sha512 = '7def6738e2fa6ab8bf5a2b8b85a4f6fbcf27947891829146d2a7f74bf4d05db094dcae91d81ca248e41658d148bc24f321af66a33c2ed3d59c4e40ceec4a0463'; `
    if ((Get-FileHash dotnet.zip -Algorithm sha512).Hash -ne $dotnet_sha512) { `
        Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
        exit 1; `
    }; `
    `
    Expand-Archive dotnet.zip -DestinationPath dotnet; `
    Remove-Item -Force dotnet.zip
    
ENV `
    # Configure web servers to bind to port 80 when present
    ASPNETCORE_URLS=http://+:80 `
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true

