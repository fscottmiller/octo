FROM mcr.microsoft.com/windows/servercore:1809 AS installer

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
ARG OCTO_TOOLS_VERSION=4.31.1
ENV OCTO_TOOLS_DOWNLOAD_URL https://download.octopusdeploy.com/octopus-tools/$OCTO_TOOLS_VERSION/OctopusTools.$OCTO_TOOLS_VERSION.portable.zip

# Retrieve Octopus CLI
RUN Invoke-WebRequest $Env:OCTO_TOOLS_DOWNLOAD_URL -OutFile OctopusTools.zip; \
	Expand-Archive OctopusTools.zip -DestinationPath octo; \
	Remove-Item -Force OctopusTools.zip; \
	mkdir src |Out-Null
	
# Runtime Image
FROM mcr.microsoft.com/dotnet/core/runtime:2.1-nanoserver-1809 

# In order to set system PATH, ContainerAdministrator must be used
USER ContainerAdministrator
RUN setx /M PATH "%PATH%;C:\Program Files\octo"
USER ContainerUser

COPY --from=installer ["/octo", "/Program Files/octo"]

ENTRYPOINT ["dotnet", "/Program Files/octo/Octo.dll"]
