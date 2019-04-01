# Before you begin - make sure you're logged in to the azure CLI
az login

# Ensure you choose the correct azure subscription if you have more than one 
$SUBSCRIPTION_NAME = "My Subscription Name"

Write-Verbose "Set the default Azure subscription" -Verbose
az account set --subscription "$SUBSCRIPTION_NAME"

$SUBSCRIPTION_ID = $(az account show --query id -o tsv)
Write-Verbose "SUBSCRIPTION_ID: $SUBSCRIPTION_ID" -Verbose

$SUBSCRIPTION_NAME = $(az account show --query name -o tsv)
Write-Verbose "SUBSCRIPTION_NAME: $SUBSCRIPTION_NAME" -Verbose

$USER_NAME = $(az account show --query user.name -o tsv)
Write-Verbose "Service Principal Name or ID: $USER_NAME" -Verbose

$TENANT_ID = $(az account show --query tenantId -o tsv)
Write-Verbose "TENANT_ID: $TENANT_ID" -Verbose

$SCRIPT_DIRECTORY = ($pwd).path
Write-Verbose "SCRIPT_DIRECTORY: $SCRIPT_DIRECTORY" -Verbose

try {

    # Add utility methods to PowerShell session
    . (Join-Path $SCRIPT_DIRECTORY "utils.ps1")

    # Add environment variable values to PowerShell session
    . (Join-Path $SCRIPT_DIRECTORY "variables.values.ps1")

    # Add session variables and show values to PowerShell session
    . (Join-Path $SCRIPT_DIRECTORY "variables.ps1")

    # Create resource (in it does not already exist)
    # az group create --location "$NET_LOCATION" --name "$NET_RG_NAME"

    # Deploy private Network Security Group resource
    . (Join-Path $SCRIPT_DIRECTORY "deployPrivateNSG.ps1")

    # Deploy public Network Security Group resource
    . (Join-Path $SCRIPT_DIRECTORY "deployPublicNSG.ps1")

    # Deploy Virtual Network resource
    . (Join-Path $SCRIPT_DIRECTORY "deployVirtualNetwork.ps1")

    # Deploy private Subnet resource
    . (Join-Path $SCRIPT_DIRECTORY "deployPrivateSubnet.ps1")

    # Deploy private Subnet resource
    . (Join-Path $SCRIPT_DIRECTORY "deployPublicSubnet.ps1")

    # Ensure that your have already created a shared Key Vault resource
    # and have granted the necessary permissions to deploy a cerrtifcate
    # and secrets to be used by the Application Gateway with WAF deployment.

    # Build the deployApplicationGatewayWAF.parameters.json file
    # needed to deploy the Application Gateway with WAF and its
    # certifacte and secrets
    . (Join-Path $SCRIPT_DIRECTORY "buildApplicationGatewayWAFParameters.ps1")    

    # Deploy Application Gateway with WAF resource
    . (Join-Path $SCRIPT_DIRECTORY "deployApplicationGatewayWAF.ps1")

}
catch {
    $ERROR_MESSAGE = $_.Exception.Message
    Write-Verbose "Error while loading or running supporting PowerShell Scripts: " -Verbose
    Write-Error "ERROR: $ERROR_MESSAGE" -Verbose
}

if ("true" -eq "$(Test-Path -Path "$KUBE_CONFIG_PATH")".ToLower()) {
    Write-Verbose "Removing kubectl config file" -Verbose
    Remove-Item –path "$KUBE_CONFIG_PATH"
}
else {
    Write-Verbose "kubectl config file does not exist" -Verbose
}
