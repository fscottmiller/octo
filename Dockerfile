FROM mcr.microsoft.com/powershell:lts-nanoserver-1809 AS downloader

ARG OCTO_TOOLS_VERSION=4.31.1
SHELL ["powershell", "-Command"]

ENV OCTO_TOOLS_DOWNLOAD_URL https://download.octopusdeploy.com/octopus-tools/$OCTO_TOOLS_VERSION/OctopusTools.$OCTO_TOOLS_VERSION.portable.zip

RUN Invoke-WebRequest $Env:OCTO_TOOLS_DOWNLOAD_URL -OutFile OctopusTools.zip; \
	Expand-Archive OctopusTools.zip -DestinationPath octo; \
	Remove-Item -Force OctopusTools.zip; \
	mkdir src |Out-Null;

FROM mcr.microsoft.com/dotnet/core/runtime:2.1-nanoserver-1809 

RUN mkdir src
COPY --from=downloader /octo

WORKDIR /src

ENTRYPOINT ["dotnet", "/octo/Octo.dll"]
