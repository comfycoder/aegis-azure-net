# Trim all leading and trailing whitespace from environment variables
# Prevents the need to tackle each var individually
Get-ChildItem Env:* | ForEach-Object {Set-Item -Path "Env:$($_.Name)" -Value $_.Value.trim()}

Write-Verbose "**************** Display Variables with Values ****************" -Verbose

$TENANT_ID = "52034371-b33a-42e9-85c2-78ec57d3d8e0"
Write-Verbose "TENANT_ID: $TENANT_ID" -Verbose

$SUBSCRIPTION_NAME = $(az account show --query name -o tsv)
Write-Verbose "SUBSCRIPTION_NAME: $SUBSCRIPTION_NAME"

$SUBSCRIPTION_ID = $(az account show --query id -o tsv)
Write-Verbose "SUBSCRIPTION_ID: $SUBSCRIPTION_ID" -Verbose

$CREATED_DATE = Get-Date -Format "yyyy-MM-dd"
Write-Verbose "CREATED_DATE: $CREATED_DATE" -Verbose

#*****************************************************************************

$NET_SHORT_NAME = "$env:NET_SHORT_NAME"

if (!($NET_SHORT_NAME)) {
    Write-Error -Message "Missing value for variable called 'NET_SHORT_NAME'" -ErrorAction Stop
}
elseif (($NET_SHORT_NAME.length -gt 8) -or ($NET_SHORT_NAME.length -lt 3)) {
    Write-Error -Message "'NET_SHORT_NAME' variable must be at least 3 character or no more that 8 characters in lenght" -ErrorAction Stop
}
Write-Verbose "NET_SHORT_NAME: $NET_SHORT_NAME" -Verbose

$APP_TEAM_AD_GROUP = "$env:APP_TEAM_AD_GROUP"
Write-Verbose "APP_TEAM_AD_GROUP: $APP_TEAM_AD_GROUP" -Verbose

$ORG = $(If ($env:ORG) { "$env:ORG" } Else { "CMFG" }) 
Write-Verbose "ORG: $ORG" -Verbose

$REGION = $(If ($env:REGION) { "$env:REGION" } Else { "EA2" }) 
Write-Verbose "REGION: $REGION" -Verbose

$AZENV = $(If ($env:AZENV) { "$env:AZENV" } Else { "NP1" })
Write-Verbose "AZENV: $AZENV" -Verbose

#*****************************************************************************

$ACR_NAME = "$env:ACR_NAME"
Write-Verbose "ACR_NAME: $ACR_NAME" -Verbose

$ACR_RG_NAME = "$env:ACR_RG_NAME"
Write-Verbose "ACR_RG_NAME: $ACR_RG_NAME" -Verbose

#*****************************************************************************

$NET_LOCATION = $(If ($env:NET_LOCATION) { "$env:NET_LOCATION" } Else { "eastus2" }) 
Write-Verbose "NET_LOCATION: $NET_LOCATION" -Verbose

$NET_NAME = "NET-$ORG-$REGION-$AZENV-$NET_SHORT_NAME"
Write-Verbose "NET_NAME: $NET_NAME" -Verbose

$NET_RG_NAME = "$env:NET_RG_NAME"
Write-Verbose "NET_RG_NAME: $NET_RG_NAME" -Verbose

$RANDOM_DNS_SUFFIX = Get-Random
$NET_DNS_NAME_PREFIX = "$NET_NAME-$RANDOM_DNS_SUFFIX".ToLower()
Write-Verbose "NET_DNS_NAME_PREFIX: $NET_DNS_NAME_PREFIX" -Verbose

$NET_AIS_LOCATION = $(If ($env:NET_AIS_LOCATION) { "$env:NET_AIS_LOCATION" } Else { "eastus" }) 
Write-Verbose "NET_AIS_LOCATION: $NET_AIS_LOCATION" -Verbose


#*****************************************************************************

$OMS_WORKSPACE_RG_NAME = "$env:OMS_WORKSPACE_RG_NAME"
Write-Verbose "OMS_WORKSPACE_RG_NAME: $OMS_WORKSPACE_RG_NAME" -Verbose

$OMS_WORKSPACE_NAME = "$env:OMS_WORKSPACE_NAME"
Write-Verbose "OMS_WORKSPACE_NAME: $OMS_WORKSPACE_NAME" -Verbose

$OMS_WORKSPACE_RESOURCE_ID = "/subscriptions/$SUBSCRIPTION_ID/resourcegroups/$OMS_WORKSPACE_RG_NAME/providers/microsoft.operationalinsights/workspaces/$OMS_WORKSPACE_NAME"
Write-Verbose "OMS_WORKSPACE_RESOURCE_ID: $OMS_WORKSPACE_RESOURCE_ID" -Verbose

#*****************************************************************************

$NSG_RG_NAME = $NET_RG_NAME
Write-Verbose "NSG_RG_NAME: $NSG_RG_NAME" -Verbose

$NSG_LOCATION = $NET_LOCATION
Write-Verbose "NSG_LOCATION: $NSG_LOCATION" -Verbose

$NSG_PRIVATE_NAME = "NSG-$ORG-$REGION-$AZENV-$NET_SHORT_NAME-Private"
Write-Verbose "NETWORK_RG_NAME: $NSG_PRIVATE_NAME" -Verbose

$NSG_PUBLIC_NAME = "NSG-$ORG-$REGION-$AZENV-$NET_SHORT_NAME-Public"
Write-Verbose "NSG_PUBLIC_NAME: $NSG_PUBLIC_NAME" -Verbose

#*****************************************************************************

$VNET_LOCATION = $NET_LOCATION
Write-Verbose "VNET_LOCATION: $VNET_LOCATION" -Verbose

$VNET_RG_NAME = $NET_RG_NAME
Write-Verbose "VNET_RG_NAME: $VNET_RG_NAME" -Verbose

$VNET_NAME = "VNet-$ORG-$REGION-$AZENV-$NET_SHORT_NAME"
Write-Verbose "VNET_NAME: $VNET_NAME" -Verbose

$VNET_ADDRESS_PREFIX = $(If ($env:VNET_ADDRESS_PREFIX) { "$env:VNET_ADDRESS_PREFIX" } Else { "10.100.0.0/16" }) 
Write-Verbose "VNET_ADDRESS_PREFIX: $VNET_ADDRESS_PREFIX" -Verbose

#*****************************************************************************

$SUBNET_PRIVATE_NAME = "$NET_SHORT_NAME-private-subnet".ToLower()
Write-Verbose "SUBNET_PRIVATE_NAME: $SUBNET_PRIVATE_NAME" -Verbose

$SUBNET_PRIVATE_ADDRESS_PREFIX = $(If ($env:SUBNET_PRIVATE_ADDRESS_PREFIX) { "$env:SUBNET_PRIVATE_ADDRESS_PREFIX" } Else { "10.100.1.0/24" }) 
Write-Verbose "SUBNET_PRIVATE_ADDRESS_PREFIX: $SUBNET_PRIVATE_ADDRESS_PREFIX" -Verbose

$SUBNET_PUBLIC_NAME = "$NET_SHORT_NAME-public-subnet".ToLower()
Write-Verbose "SUBNET_PUBLIC_NAME: $SUBNET_PUBLIC_NAME" -Verbose

$SUBNET_PUBLIC_ADDRESS_PREFIX = $(If ($env:SUBNET_PUBLIC_ADDRESS_PREFIX) { "$env:SUBNET_PUBLIC_ADDRESS_PREFIX" } Else { "10.100.0.0/24" }) 
Write-Verbose "SUBNET_PUBLIC_ADDRESS_PREFIX: $SUBNET_PUBLIC_ADDRESS_PREFIX" -Verbose

$SUBNET_SERVICE_ENDPOINTS = "Microsoft.Storage", "Microsoft.Sql", "Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.KeyVault", "Microsoft.EventHub", "Microsoft.ServiceBus"
Write-Verbose "SUBNET_SERVICE_ENDPOINTS: $SUBNET_SERVICE_ENDPOINTS" -Verbose

#*****************************************************************************

$AG_WAF_NAME = "AGWAF-$ORG-$REGION-$AZENV-$NET_SHORT_NAME"
Write-Verbose "AG_WAF_NAME: $AG_WAF_NAME" -Verbose

$AG_WAF_RG_NAME = $NET_RG_NAME
Write-Verbose "AG_WAF_RG_NAME: $AG_WAF_RG_NAME" -Verbose

$AG_WAF_LOCATION = $NET_LOCATION
Write-Verbose "AG_WAF_LOCATION: $AG_WAF_LOCATION" -Verbose

$AG_WAF_CAPACITY = "2"
Write-Verbose "AG_WAF_CAPACITY: $AG_WAF_CAPACITY" -Verbose

$AG_WAF_ENABLE_HTTP2 = "true"
Write-Verbose "AG_WAF_ENABLE_HTTP2: $AG_WAF_ENABLE_HTTP2" -Verbose

$AG_WAF_IDLE_TIMEOUT = "4"
Write-Verbose "AG_WAF_IDLE_TIMEOUT: $AG_WAF_IDLE_TIMEOUT" -Verbose

$AG_WAF_DOMAIN_NAME_LABEL_TEMP = "acg" + "$ORG" + "$REGION" + "$AZENV" + "$NET_SHORT_NAME"

$AG_WAF_DOMAIN_NAME_LABEL = "$AG_WAF_DOMAIN_NAME_LABEL_TEMP".ToLower()
Write-Verbose "AG_WAF_DOMAIN_NAME_LABEL: $AG_WAF_DOMAIN_NAME_LABEL" -Verbose

$AG_WAF_BACKEND_FQDN = "as-bs-mywebapp.azurewebsites.net"
Write-Verbose "AG_WAF_BACKEND_FQDN: $AG_WAF_BACKEND_FQDN" -Verbose


# $AG_WAF_IP_DOMAIN_PREFIX = "agwafxxxxea2np1$NET_SHORT_NAME"
# Write-Verbose "AG_WAF_IP_DOMAIN_PREFIX: $AG_WAF_IP_DOMAIN_PREFIX" -Verbose

# $AG_WAF_IP_FQDN = "$AG_WAF_IP_DOMAIN_PREFIX.$AG_WAF_LOCATION.cloudapp.azure.com".ToLower()
# Write-Verbose "AG_WAF_IP_FQDN: $AG_WAF_IP_FQDN" -Verbose

#*****************************************************************************

$NET_SHARED_VAULT_SUBSCRIPTION_NAME = "$env:NET_SHARED_VAULT_SUBSCRIPTION_NAME"
Write-Verbose "NET_SHARED_VAULT_SUBSCRIPTION_NAME: $NET_SHARED_VAULT_SUBSCRIPTION_NAME" -Verbose

$NET_SHARED_VAULT_SUBSCRIPTION_ID = $(Get-Subscription -subscription "$NET_SHARED_VAULT_SUBSCRIPTION_NAME" -queryParam "id")
Write-Verbose "NET_SHARED_VAULT_SUBSCRIPTION_ID: $NET_SHARED_VAULT_SUBSCRIPTION_ID" -Verbose

$NET_SHARED_VAULT_RG_NAME = "$env:NET_SHARED_VAULT_RG_NAME"
Write-Verbose "NET_SHARED_VAULT_RG_NAME: $NET_SHARED_VAULT_RG_NAME" -Verbose

$NET_SHARED_VAULT_NAME = "$env:NET_SHARED_VAULT_NAME"
Write-Verbose "NET_SHARED_VAULT_NAME: $NET_SHARED_VAULT_NAME" -Verbose

$NET_SHARED_VAULT_ID = "/subscriptions/$NET_SHARED_VAULT_SUBSCRIPTION_ID/resourceGroups/$NET_SHARED_VAULT_RG_NAME/providers/Microsoft.KeyVault/vaults/$NET_SHARED_VAULT_NAME".ToLower()
Write-Verbose "NET_SHARED_VAULT_ID: $NET_SHARED_VAULT_ID" -Verbose

#*****************************************************************************
# SSL Certificate Info
#*****************************************************************************

$NET_SSL_CERT_DOMAIN_NAME = "$env:NET_SSL_CERT_DOMAIN_NAME"
Write-Verbose "NET_SSL_CERT_DOMAIN_NAME: $NET_SSL_CERT_DOMAIN_NAME" -Verbose

$NET_SSL_CERT_PREFIX = "$env:NET_SSL_CERT_PREFIX"
Write-Verbose "NET_SSL_CERT_PREFIX: $NET_SSL_CERT_PREFIX" -Verbose

$NET_SSL_CERT_NAME = "$NET_SSL_CERT_PREFIX-cert"
Write-Verbose "NET_SSL_CERT_NAME: $NET_SSL_CERT_NAME" -Verbose

$NET_SSL_CERT_SECRET_NAME = "$NET_SSL_CERT_PREFIX-cert-secret"
Write-Verbose "NET_SSL_CERT_SECRET_NAME: $NET_SSL_CERT_SECRET_NAME" -Verbose

$NET_SSL_CERT_PWD_SECRET_NAME = "$NET_SSL_CERT_PREFIX-cert-password"
Write-Verbose "NET_SSL_CERT_PWD_SECRET_NAME: $NET_SSL_CERT_PWD_SECRET_NAME" -Verbose

$NET_AUTH_CERT_SECRET_NAME = "$NET_SSL_CERT_PREFIX-auth-cert"
Write-Verbose "NET_AUTH_CERT_SECRET_NAME: $NET_AUTH_CERT_SECRET_NAME" -Verbose
