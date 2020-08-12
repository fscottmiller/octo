FROM jenkins/inbound-agent:windowsservercore-1809

ARG OCTO_TOOLS_VERSION=4.31.1
ARG user=jenkins

# use powershell
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV OCTO_TOOLS_DOWNLOAD_URL https://download.octopusdeploy.com/octopus-tools/$OCTO_TOOLS_VERSION/OctopusTools.$OCTO_TOOLS_VERSION.portable.zip

# Update system path
USER ContainerAdministrator
RUN $ENV:PATH="$ENV:PATH;C:\Program Files\octo"
USER ${user}

# Retrieve Octopus CLI
RUN Invoke-WebRequest $Env:OCTO_TOOLS_DOWNLOAD_URL -OutFile OctopusTools.zip; \
	Expand-Archive OctopusTools.zip -DestinationPath octo; \
	Remove-Item -Force OctopusTools.zip; \
	mkdir src |Out-Null
