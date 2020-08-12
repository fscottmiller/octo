FROM jenkins/inbound-agent:windowsservercore-1809

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
ARG OCTO_TOOLS_VERSION=4.31.1
ARG user=jenkins
ENV OCTO_TOOLS_DOWNLOAD_URL https://download.octopusdeploy.com/octopus-tools/$OCTO_TOOLS_VERSION/OctopusTools.$OCTO_TOOLS_VERSION.portable.zip

# Retrieve Octopus CLI
RUN Invoke-WebRequest $Env:OCTO_TOOLS_DOWNLOAD_URL -OutFile OctopusTools.zip; \
	Expand-Archive OctopusTools.zip -DestinationPath octo; \
	Remove-Item -Force OctopusTools.zip; \
	mkdir src |Out-Null
	
# In order to set system PATH, ContainerAdministrator must be used
USER ContainerAdministrator
RUN $Env:Path += ";C:\Program Files\octo"
USER ${user}

