function Connect-OAuth2
{
    <#
        .SYNOPSIS
            Authenticate with OAuth2

        .DESCRIPTION
            Authenticate with OAuth2
            Get token

        .PARAMETER Uri
            Uri for authentication endpoint

        .PARAMETER ClientCredential
            Credential object with:
            Username = ClientId
            Password = ClientSecret

        .PARAMETER ClientId
            ClientId to authenticate with

        .PARAMETER ClientSecret
            ClientSecret to authenticate with

        .PARAMETER Credential
            Credential object to authenticate with (same as Username+Password)

        .PARAMETER Username
            Username to authenticate with

        .PARAMETER Password
            Password to authenticate with

        .PARAMETER AuthBody
            Extra auth body - required by some endpoints to get access to resources

        .PARAMETER ReturnToken
            Return token as string

        .PARAMETER ReturnHeader
            Return hashtable that can be used by Invoke-RestMethod and Invoke-WebRequest

        .PARAMETER ReturnResponse
            Return full response recieved from server

        .EXAMPLE
            Connect-OAuth2 -Uri "$uri/auth/token" -ClientId aaaa -ClientSecret bbbb -AuthBody @{scope = 'all'}

        .EXAMPLE
            Invoke-RestMethod -Uri "$uri/api/Info" -Headers (Connect-OAuth2 -Uri "$uri/auth/token" -ClientCredential $cred -ReturnHeader)
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true,  ValueFromPipelineByPropertyName=$true, Position = 0)]
        [string]
        $Uri,

        [Parameter(Mandatory=$true,  ValueFromPipelineByPropertyName=$true, ParameterSetName='ClientCredentialReturnToken')]
        [Parameter(Mandatory=$true,  ValueFromPipelineByPropertyName=$true, ParameterSetName='ClientCredentialReturnHeader')]
        [Parameter(Mandatory=$true,  ValueFromPipelineByPropertyName=$true, ParameterSetName='ClientCredentialReturnResponse')]
        [pscredential]
        $ClientCredential,

        [Parameter(Mandatory=$true,  ValueFromPipelineByPropertyName=$true, ParameterSetName='ClientReturnToken')]
        [Parameter(Mandatory=$true,  ValueFromPipelineByPropertyName=$true, ParameterSetName='ClientReturnHeader')]
        [Parameter(Mandatory=$true,  ValueFromPipelineByPropertyName=$true, ParameterSetName='ClientReturnResponse')]
        [string]
        $ClientId,

        [Parameter(Mandatory=$true,  ValueFromPipelineByPropertyName=$true, ParameterSetName='ClientReturnToken')]
        [Parameter(Mandatory=$true,  ValueFromPipelineByPropertyName=$true, ParameterSetName='ClientReturnHeader')]
        [Parameter(Mandatory=$true,  ValueFromPipelineByPropertyName=$true, ParameterSetName='ClientReturnResponse')]
        [string]
        $ClientSecret,

        [Parameter(Mandatory=$true,  ValueFromPipelineByPropertyName=$true, ParameterSetName='CredentialReturnToken')]
        [Parameter(Mandatory=$true,  ValueFromPipelineByPropertyName=$true, ParameterSetName='CredentialReturnHeader')]
        [Parameter(Mandatory=$true,  ValueFromPipelineByPropertyName=$true, ParameterSetName='CredentialReturnResponse')]
        [pscredential]
        $Credential,

        [Parameter(Mandatory=$true,  ValueFromPipelineByPropertyName=$true, ParameterSetName='UserPassReturnToken')]
        [Parameter(Mandatory=$true,  ValueFromPipelineByPropertyName=$true, ParameterSetName='UserPassReturnHeader')]
        [Parameter(Mandatory=$true,  ValueFromPipelineByPropertyName=$true, ParameterSetName='UserPassReturnResponse')]
        [string]
        $Username,

        [Parameter(Mandatory=$true,  ValueFromPipelineByPropertyName=$true, ParameterSetName='UserPassReturnToken')]
        [Parameter(Mandatory=$true,  ValueFromPipelineByPropertyName=$true, ParameterSetName='UserPassReturnHeader')]
        [Parameter(Mandatory=$true,  ValueFromPipelineByPropertyName=$true, ParameterSetName='UserPassReturnResponse')]
        [string]
        $Password,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [hashtable]
        $AuthBody = @{},

        [Parameter(Mandatory=$false, ParameterSetName='ClientCredentialReturnToken')]
        [Parameter(Mandatory=$false, ParameterSetName='ClientReturnToken')]
        [Parameter(Mandatory=$false, ParameterSetName='CredentialReturnToken')]
        [Parameter(Mandatory=$false, ParameterSetName='UserPassReturnToken')]
        [switch]
        $ReturnToken,

        [Parameter(Mandatory=$true, ParameterSetName='ClientCredentialReturnHeader')]
        [Parameter(Mandatory=$true, ParameterSetName='ClientReturnHeader')]
        [Parameter(Mandatory=$true, ParameterSetName='CredentialReturnHeader')]
        [Parameter(Mandatory=$true, ParameterSetName='UserPassReturnHeader')]
        [switch]
        $ReturnHeader,

        [Parameter(Mandatory=$true, ParameterSetName='ClientCredentialReturnResponse')]
        [Parameter(Mandatory=$true, ParameterSetName='ClientReturnResponse')]
        [Parameter(Mandatory=$true, ParameterSetName='CredentialReturnResponse')]
        [Parameter(Mandatory=$true, ParameterSetName='UserPassReturnResponse')]
        [switch]
        $ReturnResponse
    )

    begin
    {
        Write-Verbose -Message "Begin (ErrorActionPreference: $ErrorActionPreference)"
        $origErrorActionPreference = $ErrorActionPreference
        $verbose = $PSBoundParameters.ContainsKey('Verbose') -or ($VerbosePreference -ne 'SilentlyContinue')
    }

    process
    {
        Write-Verbose -Message "Process begin (ErrorActionPreference: $ErrorActionPreference)"

        try
        {
            # Make sure that we don't continue on error, and that we catches the error
            $ErrorActionPreference = 'Stop'

            if ($ClientCredential)
            {
                $ClientId     = $ClientCredential.UserName
                $ClientSecret = $ClientCredential.GetNetworkCredential().Password
            }

            if ($ClientId -and $ClientSecret)
            {
                $AuthBody['grant_type']    = 'client_credentials'
                $AuthBody['client_id']     = $ClientId
                $AuthBody['client_secret'] = $ClientSecret
            }

            if ($Credential)
            {
                $Username = $Credential.UserName
                $Password = $Credential.GetNetworkCredential().Password
            }

            if ($Username -and $Password)
            {
                $AuthBody['grant_type'] = 'password'
                $AuthBody['username']   = $Username
                $AuthBody['password']   = $Password
            }

            $response = Invoke-RestMethod -Method Post -Uri $Uri -Body $authBody -ErrorAction Stop

            if ($PSCmdlet.ParameterSetName -like '*ReturnResponse')
            {
                # Return
                $response
            }
            else
            {
                if (-not ($token = $response.access_token))
                {
                    throw "No auth token received from $Uri"
                }

                if ($PSCmdlet.ParameterSetName -like '*ReturnToken')
                {
                    # Return
                    $token
                }
                elseif ($PSCmdlet.ParameterSetName -like '*ReturnHeader')
                {
                    # Return
                    @{
                        Authorization = "Bearer $token"
                    }
                }
                else
                {
                    throw "Unsupported ParametersetName <$($PSCmdlet.ParameterSetName)>"
                }
            }
        }
        catch
        {
            Write-Verbose -Message "Encountered an error: $_"
            Write-Error -ErrorAction $origErrorActionPreference -Exception $_.Exception
        }
        finally
        {
            $ErrorActionPreference = $origErrorActionPreference
        }

        Write-Verbose -Message 'Process end'
    }

    end
    {
        Write-Verbose -Message 'End'
    }
}
