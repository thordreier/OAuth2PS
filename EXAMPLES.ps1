# Get OAuth2 token
Connect-OAuth2 -Uri "$uri/auth/token" -ClientId aaaa -ClientSecret bbbb

# Get OAuth2 token and use it with Invoke-RestMethod
$uri = 'https://somethinggoeshere.halopsa.com'
$cred = Get-Credential  # Username is ClientId, Password is ClientSecret
                        # If "PSVault" module is installed, then something like this could be used:
                        # $cred = Get-VaultCredential -Name OAuth2Token
$headers = Connect-OAuth2 -Uri "$uri/auth/token" -ClientCredential $cred -ReturnHeader -AuthBody @{scope = 'all'}
Invoke-RestMethod -Uri "$uri/api/Asset" -Headers $headers
