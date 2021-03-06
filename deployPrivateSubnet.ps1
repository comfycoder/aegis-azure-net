Write-Verbose "Deploying Private Subnet: $SUBNET_PRIVATE_NAME" -Verbose

$SUBNET_TEMPLATE_FILE = (Join-Path $SCRIPT_DIRECTORY "deploySubnet.json")
Write-Verbose "SUBNET_TEMPLATE_FILE: $SUBNET_TEMPLATE_FILE" -Verbose

$DEPLOYMENT_NAME = "deployPrivateSubnet-$(get-date -f yyyyMMddHHmmss)"

try {      
    az group deployment create `
        -g "$VNET_RG_NAME" `
        -n "$DEPLOYMENT_NAME" `
        --template-file "$SUBNET_TEMPLATE_FILE" `
        --parameters "existingVNETName=$VNET_NAME" `
                    "newSubnetName=$SUBNET_PRIVATE_NAME" `
                    "newSubnetAddressPrefix=$SUBNET_PRIVATE_ADDRESS_PREFIX" `
                    "nsgRGName=$NSG_RG_NAME" `
                    "nsgName=$NSG_PRIVATE_NAME"
}
catch {
    $ERROR_MESSAGE = $_.Exception.Message
    Write-Error "Error while deploying Private Subnet: $ERROR_MESSAGE" -ErrorAction Stop
}
finally {
    if ($global:lastExitCode) {
        Write-Error "Error while deploying Private Subnet" -ErrorAction Stop
    }
}

Write-Verbose "Successfully Deployed Private Subnet: $SUBNET_PRIVATE_NAME" -Verbose
