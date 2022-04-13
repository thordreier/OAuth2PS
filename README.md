# OAuth2PS

PowerShell functions to authenticate with OAuth2.

## Usage

### Examples

```powershell
# Get OAuth2 token
Connect-OAuth2 -Uri "$uri/auth/token" -ClientId aaaa -ClientSecret bbbb

# Get OAuth2 token and use it with Invoke-RestMethod
$uri = 'https://somethinggoeshere.halopsa.com'
$cred = Get-Credential  # Username is ClientId, Password is ClientSecret
                        # If "PSVault" module is installed, then something like this could be used:
                        # $cred = Get-VaultCredential -Name OAuth2Token
$headers = Connect-OAuth2 -Uri "$uri/auth/token" -ClientCredential $cred -ReturnHeader -AuthBody @{scope = 'all'}
Invoke-RestMethod -Uri "$uri/api/Asset" -Headers $headers

```

Examples are also found in [EXAMPLES.ps1](EXAMPLES.ps1).

### Functions

See [FUNCTIONS.md](FUNCTIONS.md) for documentation of functions in this module.

## Install

### Install module from PowerShell Gallery

```powershell
Install-Module OAuth2PS
```

### Install module from source

```powershell
git clone https://github.com/thordreier/OAuth2PS.git
cd OAuth2PS
git pull
.\Build.ps1 -InstallModule
```
