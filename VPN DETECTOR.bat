@echo off
setlocal enabledelayedexpansion

:: Check if curl is available
curl --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] curl is not installed. Make sure you have Windows 10+ or curl.exe in your PATH.
    pause
    exit /b
)

:: Prompt for IP address
set /p IP=Enter IP address to check: 

:: Fetch info from ipinfo.io
curl -s https://ipinfo.io/%IP%/json > temp.json

:: Extract organization
for /f "tokens=2 delims=:" %%A in ('findstr /i "\"org\"" temp.json') do (
    set ORG=%%A
    set ORG=!ORG:"=!
    set ORG=!ORG:~1!
)

:: Extract country
for /f "tokens=2 delims=:" %%A in ('findstr /i "\"country\"" temp.json') do (
    set COUNTRY=%%A
    set COUNTRY=!COUNTRY:"=!
    set COUNTRY=!COUNTRY:~1!
)

echo.
echo IP: %IP%
echo Country: !COUNTRY!
echo Organization: !ORG!

:: VPN check against known providers
echo !ORG! | findstr /i "vpn digitalocean ovh linode amazon azure google hetzner nord m247 surfshark express" >nul
if %errorlevel%==0 (
    echo 🔒 This IP appears to belong to a VPN or hosting provider.
) else (
    echo ✅ This IP does not appear to be a VPN.
)

:: Clean up
del temp.json >nul 2>&1

pause
endlocal
