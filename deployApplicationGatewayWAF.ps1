
Write-Verbose "Deploying Application Gateway with WAF (v1): $AKS_NAME" -Verbose

$AG_WAF_TEMPLATE_FILE = (Join-Path $SCRIPT_DIRECTORY "deployApplicationGatewayWAF.json")
Write-Verbose "AG_WAF_TEMPLATE_FILE: $AG_WAF_TEMPLATE_FILE" -Verbose

$AG_WAF_PARAMETERS_FILE = (Join-Path $SCRIPT_DIRECTORY "deployApplicationGatewayWAF.parameters.json")
Write-Verbose "AG_WAF_PARAMETERS_FILE: $AG_WAF_PARAMETERS_FILE" -Verbose

$JSON_FILE = Test-Path $AG_WAF_PARAMETERS_FILE
If ($JSON_FILE -ne $true) {
    Write-Error "Unable to locate file: $AG_WAF_PARAMETERS_FILE"  -ErrorAction Stop
}

$DEPLOYMENT_NAME = "deployApplicationGatewayWAF-$(get-date -f yyyyMMddHHmmss)"
Write-Verbose "DEPLOYMENT_NAME: $DEPLOYMENT_NAME" -Verbose

# Validate deployment ARM template and parameters
az group deployment validate `
    -g "$AG_WAF_RG_NAME" `
    --template-file "$AG_WAF_TEMPLATE_FILE" `
    --parameters `@$AG_WAF_PARAMETERS_FILE `
    --parameters "gatewayName=$AG_WAF_NAME" `
                "gatewayLocation=$AG_WAF_LOCATION" `
                "capacity=$AG_WAF_CAPACITY" `
                "vnetRGName=$VNET_RG_NAME" `
                "vnetName=$VNET_NAME" `
                "subnetName=$SUBNET_PUBLIC_NAME" `
                "enableHttp2=$AG_WAF_ENABLE_HTTP2" `
                "idleTimeout=$AG_WAF_IDLE_TIMEOUT" `
                "domainNameLabel=$AG_WAF_DOMAIN_NAME_LABEL" `
                "backendFQDN=$AG_WAF_BACKEND_FQDN" 

# Deploy application gateway with WAF to resource group
az group deployment create `
    -g "$AG_WAF_RG_NAME" `
    -n "$DEPLOYMENT_NAME" `
    --template-file "$AG_WAF_TEMPLATE_FILE" `
    --parameters `@$AG_WAF_PARAMETERS_FILE `
    --parameters "gatewayName=$AG_WAF_NAME" `
                "gatewayLocation=$AG_WAF_LOCATION" `
                "capacity=$AG_WAF_CAPACITY" `
                "vnetRGName=$VNET_RG_NAME" `
                "vnetName=$VNET_NAME" `
                "subnetName=$SUBNET_PUBLIC_NAME" `
                "enableHttp2=$AG_WAF_ENABLE_HTTP2" `
                "idleTimeout=$AG_WAF_IDLE_TIMEOUT" `
                "domainNameLabel=$AG_WAF_DOMAIN_NAME_LABEL" `
                "backendFQDN=$AG_WAF_BACKEND_FQDN" 

Write-Verbose "Successfully Deployed Application Gateway with WAF (v1): $AG_WAF_NAME" -Verbose

$gatewayInfo = $(az network application-gateway show --name "$AG_WAF_NAME" --resource-group "$VNET_RG_NAME") | ConvertFrom-Json 
$ipAddress = $(az network public-ip show --ids $gatewayInfo.frontendIpConfigurations.publicIpAddress.id --query "ipAddress" -o tsv)

Write-Verbose "Gateway listening at IP address: https://$ipAddress !!!!!!!!" -Verbose
