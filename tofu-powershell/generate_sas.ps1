$AccountName = $args[0]

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
#Start-Sleep -Seconds 1
#"Script was invoked $AccountName" | Out-File -FilePath "$env:TEMP\terraform_debug_log.txt"


# Generate the SAS token using Azure CLI
$SasToken = az storage account generate-sas `
    --permissions "rwdlacu" `
    --account-name $AccountName `
    --services t `
    --resource-types sco `
    --expiry "2026-12-31T23:59Z" `
    --https-only `
    --output tsv

# "Script was invoked $SasToken" | Out-File -FilePath "$env:TEMP\terraform_debug_log.txt"

# Trim any trailing newline or spaces
$SasToken = $SasToken.Trim()

# Clean JSON with only the desired key
@{ sas = $SasToken } | ConvertTo-Json -Compress

