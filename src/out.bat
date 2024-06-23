@echo off
setlocal enabledelayedexpansion

rem Extract the IPv4 address
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /r /c:"IPv4.*[0-9]"') do (
    set ip=%%A
)

rem Remove leading spaces
set ip=%ip:~1%

rem Write to .env file
echo API_URL="http://%ip%:8000" > ./hermes/.env
