FROM mcr.microsoft.com/windows/servercore:1809-amd64 AS installer

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
ARG OCTO_TOOLS_VERSION=4.31.1
ENV OCTO_TOOLS_DOWNLOAD_URL https://download.octopusdeploy.com/octopus-tools/$OCTO_TOOLS_VERSION/OctopusTools.$OCTO_TOOLS_VERSION.portable.zip

# Retrieve Octopus CLI
RUN Invoke-WebRequest $Env:OCTO_TOOLS_DOWNLOAD_URL -OutFile OctopusTools.zip; \
	Expand-Archive OctopusTools.zip -DestinationPath octo; \
	Remove-Item -Force OctopusTools.zip; \
	mkdir src |Out-Null
	
# Runtime Image
FROM mcr.microsoft.com/dotnet/core/runtime2.1-nanoserver-1809 

RUN mkdir /src
WORKDIR /src

COPY --from=installer ["/octo", "."]

ENTRYPOINT ["dotnet", "./octo/Octo.dll"]
