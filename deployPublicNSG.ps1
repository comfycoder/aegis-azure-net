Write-Verbose "Deploying Public NSG: $NSG_PUBLIC_NAME" -Verbose

$NSG_PUBLIC_TEMPLATE_FILE = (Join-Path $SCRIPT_DIRECTORY "deployPublicNSG.json")
Write-Verbose "NSG_PUBLIC_TEMPLATE_FILE: $NSG_PUBLIC_TEMPLATE_FILE" -Verbose

$DEPLOYMENT_NAME = "deployPublicNSG-$(get-date -f yyyyMMddHHmmss)"

try {      
    az group deployment create `
        -g "$NSG_RG_NAME" `
        -n "$DEPLOYMENT_NAME" `
        --template-file "$NSG_PUBLIC_TEMPLATE_FILE" `
        --parameters "nsgName=$NSG_PUBLIC_NAME" `
                    "nsgLocation=$NSG_LOCATION"
}
catch {
    $ERROR_MESSAGE = $_.Exception.Message
    Write-Error "Error while deploying Public NSG: $ERROR_MESSAGE" -ErrorAction Stop
}
finally {
    if ($global:lastExitCode) {
        Write-Error "Error while deploying Public NSG" -ErrorAction Stop
    }
}

Write-Verbose "Successfully Deployed Public NSG: $NSG_PUBLIC_NAME" -Verbose
