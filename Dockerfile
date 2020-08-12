FROM mcr.microsoft.com/dotnet/core/runtime:2.1-nanoserver-1809
# MAINTAINER robert.erez devops@octopus.com
ARG OCTO_TOOLS_VERSION=4.31.1
# use powershell not batch
SHELL ["powershell", "-Command"]

LABEL maintainer="devops@octopus.com" \ 
	octopus.dockerfile.version="1.0" \
	octopus.tools.version=$OCTO_TOOLS_VERSION 

ENV OCTO_TOOLS_DOWNLOAD_URL https://download.octopusdeploy.com/octopus-tools/$OCTO_TOOLS_VERSION/OctopusTools.$OCTO_TOOLS_VERSION.portable.zip

RUN Write-Output foo
RUN Invoke-WebRequest $Env:OCTO_TOOLS_DOWNLOAD_URL -OutFile OctopusTools.zip; 
RUN Expand-Archive OctopusTools.zip -DestinationPath octo; 
RUN Remove-Item -Force OctopusTools.zip
RUN mkdir src |Out-Null

WORKDIR /src
ENTRYPOINT ["dotnet", "/octo/Octo.dll"]
