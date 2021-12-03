function Connect-OAuth2
{
    <#
        FIXXXME - write help stuff
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

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [hashtable]
        $AuthBody = @{},

        [Parameter(Mandatory=$false, ParameterSetName='ClientCredentialReturnToken')]
        [Parameter(Mandatory=$false, ParameterSetName='ClientReturnToken')]
        [switch]
        $ReturnToken,

        [Parameter(Mandatory=$true, ParameterSetName='ClientCredentialReturnHeader')]
        [Parameter(Mandatory=$true, ParameterSetName='ClientReturnHeader')]
        [switch]
        $ReturnHeader,

        [Parameter(Mandatory=$true, ParameterSetName='ClientCredentialReturnResponse')]
        [Parameter(Mandatory=$true, ParameterSetName='ClientReturnResponse')]
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

            $AuthBody['grant_type']    = 'client_credentials'
            $AuthBody['client_id']     = $ClientId
            $AuthBody['client_secret'] = $ClientSecret

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