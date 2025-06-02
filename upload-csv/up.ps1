param (
    [string]$csvFile = "my.csv",
    [string]$storageAccountName = $env:TF_VAR_storage_account_name,
    [string]$resourceGroupName = $env:TF_VAR_workshop_name,
    [string]$tableName = $env:TF_VAR_table_name,
    [string]$table_sas_url = $env:table_sas_url
)

function sendToAzureTables {
    param (
        [Parameter(Mandatory)]
        [PSCustomObject]$entity
    )

    $entity = $entity | ConvertTo-Json -Depth 3
 
    # Set headers
    $headers = @{
        Accept        = "application/json;odata=nometadata"
        "Content-Type" = "application/json"
    }

    # $entity

    # Send the request
    Invoke-RestMethod -Uri $table_sas_url -Method Post -Body $entity -Headers $headers
}

$rows = Import-Csv -Path $csvFile
$rowIndex = 1

foreach ($row in $rows) {
    $result = [PSCustomObject]@{
        PartitionKey = "workshop"
        RowKey       = "{0:D8}" -f $rowIndex  # zero-padded counter, e.g., 00000001
    }

    # Add CSV columns to entity
    foreach ($property in $row.PSObject.Properties) {
	# prepend every row name with a "_" to avoid rejection of colums starting with a number.
        $result | Add-Member -NotePropertyName "_$($property.Name)" -NotePropertyValue $property.Value
    }

    sendToAzureTables -entity $result

    $rowIndex++
}
