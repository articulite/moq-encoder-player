# Create certs directory if it doesn't exist
$certsDir = "certs"
if (-not (Test-Path $certsDir)) {
    New-Item -ItemType Directory -Path $certsDir | Out-Null
}

# Generate self-signed certificate
$cert = New-SelfSignedCertificate `
    -DnsName "localhost" `
    -CertStoreLocation "Cert:\LocalMachine\My" `
    -NotAfter (Get-Date).AddDays(10) `
    -KeyAlgorithm "ECDSA_nistP384" `
    -KeyUsage DigitalSignature `
    -FriendlyName "MOQ Test Certificate"

# Export the certificate with private key
$certPassword = ConvertTo-SecureString -String "password" -Force -AsPlainText
$certPath = Join-Path $certsDir "certificate.pfx"
Export-PfxCertificate -Cert $cert -FilePath $certPath -Password $certPassword | Out-Null
Write-Host "Created $certPath"

# Export the public certificate
$pemPath = Join-Path $certsDir "certificate.pem"
$cert | Export-Certificate -FilePath $pemPath -Type CERT | Out-Null
Write-Host "Created $pemPath"

# Export the certificate fingerprint
$fingerprintPath = Join-Path $certsDir "certificate_fingerprint.hex"
$cert.Thumbprint | Set-Content $fingerprintPath
Write-Host "Created $fingerprintPath"

# Clean up the certificate from the store
Remove-Item -Path $cert.PSPath

Write-Host "`nCertificate generation complete."
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 