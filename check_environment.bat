@echo off
echo Checking environment for MOQ Encoder/Player...
echo.

echo Checking Python installation...
python --version 2>nul
if %errorLevel% neq 0 (
    echo [X] Python is not installed or not in PATH
    echo Please install Python from https://www.python.org/
) else (
    echo [✓] Python is installed
)
echo.

echo Checking Node.js installation...
node --version 2>nul
if %errorLevel% neq 0 (
    echo [X] Node.js is not installed or not in PATH
    echo Please install Node.js from https://nodejs.org/
) else (
    echo [✓] Node.js is installed
)
echo.

echo Checking certificates...
if exist "certs\certificate.pem" (
    if exist "certs\certificate.key" (
        if exist "certs\certificate_fingerprint.hex" (
            echo [✓] All required certificates are present
        ) else (
            echo [X] Missing certificate fingerprint
            echo Please run create_self_signed_certs.bat as administrator
        )
    ) else (
        echo [X] Missing certificate key file
        echo Please run create_self_signed_certs.bat as administrator
    )
) else (
    echo [X] Missing certificate files
    echo Please run create_self_signed_certs.bat as administrator
)
echo.

echo Checking system capabilities...
echo [✓] Brave browser with WebTransport flag is enabled (user confirmed)
echo.

echo Checking required scripts...
if exist "create_self_signed_certs.bat" (
    echo [✓] Certificate generation script found
) else (
    echo [X] Certificate generation script missing
)

if exist "start-http-server-cross-origin-isolated.py" (
    echo [✓] HTTP server script found
) else (
    echo [X] HTTP server script missing
)
echo.

echo Environment check complete!
echo.
echo Note: Make sure your Brave browser has the following features enabled:
echo - WebTransport (already confirmed)
echo - WebCodecs API
echo - SharedArrayBuffer
echo - AudioWorklet
echo.
pause 