FROM mcr.microsoft.com/windows/servercore:ltsc2019

SHELL ["powershell", "-Command"]

ENV CHOCO_URL=https://chocolatey.org/install.ps1

# chocolatey
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = `\
        [System.Net.SecurityProtocolType]'Tls,Tls11,Tls12'; \
    iex ((New-Object System.Net.WebClient).DownloadString("$env:CHOCO_URL"))

RUN &C:\ProgramData\chocolatey\bin\choco feature disable -n showDownloadProgress; \
    &C:\ProgramData\chocolatey\bin\choco feature enable -n allowGlobalConfirmation

RUN &C:\ProgramData\chocolatey\bin\choco install python

RUN python -m pip install --upgrade --quiet --quiet wheel pip

RUN &C:\ProgramData\chocolatey\bin\choco list --local-only

RUN STATIC_DEPS=true python -m pip install -U lxml --no-cache-dir
