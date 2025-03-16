@echo off
REM Windows batch file to create self-signed certificates
REM Requires OpenSSL to be installed and in the PATH

REM Create certs directory if it doesn't exist
if not exist certs mkdir certs

REM Generate private key using secp384r1 curve
set KEY_FILE=certs\certificate.key
openssl ecparam -name secp384r1 -genkey -out %KEY_FILE%
echo Created %KEY_FILE%

REM Create self-signed certificate
set CERT_FILE=certs\certificate.pem
openssl req -new -x509 -days 10 -subj "/CN=Test Certificate" -addext "subjectAltName = DNS:localhost" -key %KEY_FILE% -sha384 -out %CERT_FILE%
echo Created %CERT_FILE%

REM Compute fingerprint
set FINGERPRINT_FILE=certs\certificate_fingerprint.hex
openssl x509 -in %CERT_FILE% -outform der | openssl dgst -sha256 -binary > %FINGERPRINT_FILE%
echo Created %FINGERPRINT_FILE%

echo.
echo Certificate generation complete.
pause

net session >nul 2>&1
if %errorLevel% == 0 (
    powershell -ExecutionPolicy Bypass -File "%~dp0create_self_signed_certs.ps1"
) else (
    echo Please run this script as Administrator
    echo Right-click on this batch file and select "Run as administrator"
    pause
    exit /b 1
) 