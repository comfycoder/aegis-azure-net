Write-Verbose "**************** Set Variable Values ****************" -Verbose

$env:RELEASE_REQUESTEDFOREMAIL = "me@mydomain.com"

$env:APP_TEAM_AD_GROUP = "R-Azure-MyTeamName"

#*****************************************************************************
# Common Resource Name Parts
#*****************************************************************************

$env:ORG = "MyOrg"

$env:REGION = "EA2"

$env:AZENV = "NP1"

#*****************************************************************************
# Azure Container Registry
#*****************************************************************************

$env:ACR_NAME = "acrmyregistry"

$env:ACR_RG_NAME = "RG-MY-ACR"

#*****************************************************************************
# Network Variables
#*****************************************************************************

$env:NET_NAME = "MyNetworkName"

$env:NET_SHORT_NAME = "MyAppSys"  #-$(Get-Random-Short-Name)"

$env:NET_RG_NAME = "RG-$env:ORG-$env:REGION-$env:NET_NAME-$env:NET_SHORT_NAME"

#*****************************************************************************
# OMS/Log Analytics
#*****************************************************************************

$env:OMS_WORKSPACE_RG_NAME = "rg-my-ea1-monitoring"

$env:OMS_WORKSPACE_NAME = "ommylogs"

#*****************************************************************************
# Network Security Groups (NSG)
#*****************************************************************************

$env:NSG_PRIVATE_NAME = "NSG-$env:ORG-$env:REGION-$env:AZENV-$env:NET_NAME-$env:NET_SHORT_NAME-Private"

$env:NSG_PUBLIC_NAME = "NSG-$env:ORG-$env:REGION-$env:AZENV-$env:NET_NAME-$env:NET_SHORT_NAME-Public"

#*****************************************************************************
# Virtual Network (VNet)
#*****************************************************************************

$env:VNET_NAME = "VNet-$env:ORG-$env:REGION-$env:AZENV-$env:NET_NAME-$env:NET_SHORT_NAME"

$env:VNET_ADDRESS_PREFIX = "10.100.0.0/16"

#*****************************************************************************
# Subnet
#*****************************************************************************

$env:SUBNET_PRIVATE_NAME = "$env:NET_SHORT_NAME-private-subnet".ToLower()

$env:SUBNET_PRIVATE_ADDRESS_PREFIX = "10.100.1.0/24"

$env:SUBNET_PUBLIC_NAME = "$env:NET_SHORT_NAME-public-subnet".ToLower()

$env:SUBNET_PUBLIC_ADDRESS_PREFIX ="10.100.0.0/24"

#*****************************************************************************
# Shared Net Vault
#*****************************************************************************

$env:NET_SHARED_VAULT_SUBSCRIPTION_NAME = "My Subscription Name"

$env:NET_SHARED_VAULT_RG_NAME = "RG-MY-Shared-Resources"

$env:NET_SHARED_VAULT_NAME = "kv-MY-ea2-np1-shared"

#*****************************************************************************
# SSL Certificate Info
#*****************************************************************************

$env:NET_SSL_CERT_DOMAIN_NAME = "mydomain.com"

$env:NET_SSL_CERT_PREFIX = "mydomain-com"
