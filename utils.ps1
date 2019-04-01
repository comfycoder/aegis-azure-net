function Get-Subscription
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$subscription, 
        [Parameter(Mandatory=$false)][string]$queryParam
    )

    $result = $null

    try {
        If ($queryParam) {
            Write-Verbose "Getting Virtual Network value for '$queryParam'" -Verbose
            $result = az account show --subscription "$subscription" --query "$queryParam" -o tsv 2> $null
        }
        Else {
            Write-Verbose "Getting Virtual Network json data" -Verbose
            $result = az account show --subscription "$subscription" 2> $null
        }
    }
    catch {    
    }
    finally {
        $global:lastExitCode = $null
    }

    return $result
}

function Set-Self-Signed-Cert
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$domainName, 
        [Parameter(Mandatory=$true)][string]$certSubject, 
        [Parameter(Mandatory=$true)][string]$certPwd,
        [Parameter(Mandatory=$true)][string]$certKeyVaultName,
        [Parameter(Mandatory=$true)][string]$certPrefix
    )

    $result = $null

    try {       
        
        Write-Verbose "SSL Cert Domain Name: $domainName" -Verbose
        
        Write-Verbose "SSL Cert Subject: $certSubject" -Verbose

        Write-Verbose "SSL Cert Password: $certPwd" -Verbose
        
        $KEY_FILE_NAME = $SCRIPT_DIRECTORY + "\" + $domainName + '.key'
        Write-Verbose "Key file name: $KEY_FILE_NAME" -Verbose
        
        $CRT_FILE_NAME = $SCRIPT_DIRECTORY + "\" + $domainName + '.crt'
        Write-Verbose "CRT file name: $CRT_FILE_NAME" -Verbose
        
        $PFX_FILE_NAME = $SCRIPT_DIRECTORY + "\" + $domainName + ".pfx"
        Write-Verbose "PFX file name: $PFX_FILE_NAME" -Verbose

        $SSL_CERT_PREFIX = "$certPrefix"
        Write-Verbose "SSL_CERT_PREFIX: $SSL_CERT_PREFIX" -Verbose
        
        $SSL_CERT_NAME = "$SSL_CERT_PREFIX-cert"
        Write-Verbose "Key Vault Certificate Name: $SSL_CERT_NAME" -Verbose
        
        $PFX_CERT_SECRET_NAME = "$SSL_CERT_PREFIX-cert-secret"
        Write-Verbose "PFX File Key Vault Secret Name: $PFX_CERT_SECRET_NAME" -Verbose
        
        $PFX_PWD_SECRET_NAME = "$SSL_CERT_PREFIX-cert-password"
        Write-Verbose "PFX Password Key Vault Secret Name: $PFX_PWD_SECRET_NAME" -Verbose
        
        # Create SSL Cert Key and Crt files
        openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 `
            -keyout "$KEY_FILE_NAME" -out "$CRT_FILE_NAME" `
            -subj "$certSubject"
        
        # Create PFX file with password
        openssl pkcs12 -export -out "$PFX_FILE_NAME" `
            -inkey "$KEY_FILE_NAME" -in "$CRT_FILE_NAME" `
            -passin "pass:$certSecret" -passout "pass:$certSecret"

        # Convert PFX file to base64 string
        $PFX_BASE64 = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$PFX_FILE_NAME"))
        Write-Verbose "PFX base64: $PFX_BASE64" -Verbose

        # Upload SSL Certificate to Key Vault (Does not work yet)
        # You could manually upload the certificate to the key vault
        # az keyvault certificate import -n "$NET_SSL_CERT_NAME" `
        #     --vault-name "$certKeyVaultName"  `
        #     --file "$PFX_FILE_NAME" `
        #     --password "$certPwd"

        # Set PFX file secret
        az keyvault secret set --name "$PFX_CERT_SECRET_NAME" `
            --vault-name "$certKeyVaultName" `
            --value "$PFX_BASE64"

        # Set Cert Password Secret
        az keyvault secret set --name "$PFX_PWD_SECRET_NAME" `
            --vault-name "$certKeyVaultName" `
            --value "$certPwd"
    }
    catch {    
    }
    finally {
        $global:lastExitCode = $null
    }

    return $result
}

<#

# Call Set-Self-Signed-Cert using something like the following:

$SSL_CERT_DOMAIN_NAME = "mydomain.com"
Write-Verbose "SSL Cert Domain Name: $SSL_CERT_DOMAIN_NAME" -Verbose

$SSL_CERT_SUBJECT = "/C=US/ST=My State/L=My Location/O=My Organization/CN=mydomain.com"
Write-Verbose "SSL Cert Subject: $SSL_CERT_SUBJECT" -Verbose

$SSL_CERT_PASSWORD = Get-SSL-Cert-Password # "xxxxxxxxxx"
Write-Verbose "SSL Cert Password: $SSL_CERT_PASSWORD" -Verbose

Set-Self-Signed-Cert -domainName "$SSL_CERT_DOMAIN_NAME" `
    -certSubject "$SSL_CERT_SUBJECT" -certPwd "$SSL_CERT_PASSWORD" `
    -certKeyVaultName "kv-bs-ea2-np1-shared" -certPrefix "jazzbox-net"

#>