$AG_TEMPLATE_PARAMETERS_JSON = 
'
{
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "frontendCertData": {
            "reference": {
                "keyVault": {
                    "id": "__NET_SHARED_VAULT_ID__"
                },
                "secretName": "__NET_SSL_CERT_SECRET_NAME__"
            }
        },
        "frontendCertPassword": {
            "reference": {
                "keyVault": {
                    "id": "__NET_SHARED_VAULT_ID__"
                },
                "secretName": "__NET_SSL_CERT_PWD_SECRET_NAME__"
            }
        }
    }
}
'

if ($AG_TEMPLATE_PARAMETERS_JSON) {

    Write-Verbose "Converting Application Gateway ARM Template Parameters from JSON to PowerShell Object" -Verbose

    $AG_TEMPLATE_PARAMETERS = ConvertFrom-Json -InputObject $AG_TEMPLATE_PARAMETERS_JSON

    if ($AG_TEMPLATE_PARAMETERS) {
    
        Write-Verbose "Setting Application Gateway ARM Template Parameters" -Verbose
    
        if ($AG_TEMPLATE_PARAMETERS.parameters) {

            if ($AG_TEMPLATE_PARAMETERS.parameters.frontendCertData.reference.keyVault.id) {
                Write-Verbose "Setting frontendCertData key vault id" -Verbose
                $AG_TEMPLATE_PARAMETERS.parameters.frontendCertData.reference.keyVault.id = "$NET_SHARED_VAULT_ID"
            }
            else {
                Write-Error "Unable to set frontendCertData key vault id" -ErrorAction Stop
            }

            if ($AG_TEMPLATE_PARAMETERS.parameters.frontendCertData.reference.secretName) {
                Write-Verbose "Setting frontendCertData secretName" -Verbose
                $AG_TEMPLATE_PARAMETERS.parameters.frontendCertData.reference.secretName = "$NET_SSL_CERT_SECRET_NAME"
            }
            else {
                Write-Error "Unable to set frontendCertData secretName" -ErrorAction Stop
            }

            if ($AG_TEMPLATE_PARAMETERS.parameters.frontendCertPassword.reference.keyVault.id) {
                Write-Verbose "Setting frontendCertPassword key vault id" -Verbose
                $AG_TEMPLATE_PARAMETERS.parameters.frontendCertPassword.reference.keyVault.id = "$NET_SHARED_VAULT_ID"
            }
            else {
                Write-Error "Unable to set frontendCertPassword key vault id" -ErrorAction Stop
            }

            if ($AG_TEMPLATE_PARAMETERS.parameters.frontendCertPassword.reference.secretName) {
                Write-Verbose "Setting frontendCertPassword secretName" -Verbose
                $AG_TEMPLATE_PARAMETERS.parameters.frontendCertPassword.reference.secretName = "$NET_SSL_CERT_PWD_SECRET_NAME"
            }
            else {
                Write-Error "Unable to set frontendCertPassword secretName" -ErrorAction Stop
            }
        }
        else {
            Write-Error "Missing 'parameter' section in template parameters" -ErrorAction Stop
        }
    }
    else {
        Write-Error "Unable to convert json to ps object" -ErrorAction Stop
    }
}

$AG_WAF_PARAMETERS_FILE = (Join-Path $SCRIPT_DIRECTORY "deployApplicationGatewayWAF.parameters.json")
Write-Verbose "AG_WAF_PARAMETERS_FILE: $AG_WAF_PARAMETERS_FILE" -Verbose

$AG_TEMPLATE_PARAMETERS_OUT = ConvertTo-Json -InputObject $AG_TEMPLATE_PARAMETERS -Depth 5

Out-File -FilePath $AG_WAF_PARAMETERS_FILE -InputObject $AG_TEMPLATE_PARAMETERS_OUT -Force

$JSON_FILE = Test-Path $AG_WAF_PARAMETERS_FILE
If ($JSON_FILE -ne $true) {
    Write-Error "Unable to locate file: $AG_WAF_PARAMETERS_FILE"  -ErrorAction Stop
}
