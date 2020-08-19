FROM mcr.microsoft.com/dotnet/core/runtime:2.1
ARG OCTO_TOOLS_VERSION=4.31.1

LABEL maintainer="devops@octopus.com" 
LABEL octopus.dockerfile.version="1.0"
LABEL octopus.tools.version=$OCTO_TOOLS_VERSION 

COPY OctopusTools.$OCTO_TOOLS_VERSION.portable.zip ./octo/OctopusTools.zip

RUN Expand-Archive ./octo/OctopusTools.zip -DestinationPath octo; \
	Remove-Item -Force ./octo/OctopusTools.zip; \
	mkdir src |Out-Null

WORKDIR /src
ENTRYPOINT ["dotnet", "/octo/octo.dll"]
