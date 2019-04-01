Write-Verbose "Deploying Private NSG: $NSG_PRIVATE_NAME" -Verbose

$NSG_PRIVATE_TEMPLATE_FILE = (Join-Path $SCRIPT_DIRECTORY "deployPrivateNSG.json")
Write-Verbose "NSG_PRIVATE_TEMPLATE_FILE: $NSG_PRIVATE_TEMPLATE_FILE" -Verbose

$DEPLOYMENT_NAME = "deployPrivateNSG-$(get-date -f yyyyMMddHHmmss)"

try {      
    az group deployment create `
        -g "$NSG_RG_NAME" `
        -n "$DEPLOYMENT_NAME" `
        --template-file "$NSG_PRIVATE_TEMPLATE_FILE" `
        --parameters "nsgName=$NSG_PRIVATE_NAME" `
                    "nsgLocation=$NSG_LOCATION" 
}
catch {
    $ERROR_MESSAGE = $_.Exception.Message
    Write-Error "Error while deploying Private NSG: $ERROR_MESSAGE" -ErrorAction Stop
}
finally {
    if ($global:lastExitCode) {
        Write-Error "Error while deploying Private NSG" -ErrorAction Stop
    }
}

Write-Verbose "Successfully Deployed Private NSG: $NSG_PRIVATE_NAME" -Verbose
