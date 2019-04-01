Write-Verbose "Deploying Virtual Network: $VNET_NAME" -Verbose

$VNET_TEMPLATE_FILE = (Join-Path $SCRIPT_DIRECTORY "deployVirtualNetwork.json")
Write-Verbose "VNET_TEMPLATE_FILE: $VNET_TEMPLATE_FILE" -Verbose

$DEPLOYMENT_NAME = "deployVirtualNetwork-$(get-date -f yyyyMMddHHmmss)"

try {      
    az group deployment create `
        -g "$VNET_RG_NAME" `
        -n "$DEPLOYMENT_NAME" `
        --template-file "$VNET_TEMPLATE_FILE" `
        --parameters "vnetName=$VNET_NAME" `
                    "addressPrefix=$VNET_ADDRESS_PREFIX" `
                    "vnetLocation=$VNET_LOCATION"
}
catch {
    $ERROR_MESSAGE = $_.Exception.Message
    Write-Error "Error while deploying virtual network: $ERROR_MESSAGE" -ErrorAction Stop
}
finally {
    if ($global:lastExitCode) {
        Write-Error "Error while deploying virtual network" -ErrorAction Stop
    }
}

Write-Verbose "Successfully Deployed Virtual Network: $VNET_NAME" -Verbose
