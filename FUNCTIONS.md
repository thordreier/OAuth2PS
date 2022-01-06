# OAuth2PS

Text in this document is automatically created - don't change it manually

## Index

[Connect-OAuth2](#Connect-OAuth2)<br>

## Functions

<a name="Connect-OAuth2"></a>
### Connect-OAuth2

```

NAME
    Connect-OAuth2
    
SYNOPSIS
    Authenticate with OAuth2
    
    
SYNTAX
    Connect-OAuth2 [-Uri] <String> -ClientCredential <PSCredential> [-AuthBody <Hashtable>] -ReturnResponse [<CommonParameters>]
    
    Connect-OAuth2 [-Uri] <String> -ClientCredential <PSCredential> [-AuthBody <Hashtable>] -ReturnHeader [<CommonParameters>]
    
    Connect-OAuth2 [-Uri] <String> -ClientCredential <PSCredential> [-AuthBody <Hashtable>] [-ReturnToken] [<CommonParameters>]
    
    Connect-OAuth2 [-Uri] <String> -ClientId <String> -ClientSecret <String> [-AuthBody <Hashtable>] -ReturnResponse [<CommonParameters>]
    
    Connect-OAuth2 [-Uri] <String> -ClientId <String> -ClientSecret <String> [-AuthBody <Hashtable>] -ReturnHeader [<CommonParameters>]
    
    Connect-OAuth2 [-Uri] <String> -ClientId <String> -ClientSecret <String> [-AuthBody <Hashtable>] [-ReturnToken] [<CommonParameters>]
    
    
DESCRIPTION
    Authenticate with OAuth2
    Get token
    

PARAMETERS
    -Uri <String>
        Uri for authentication endpoint
        
    -ClientCredential <PSCredential>
        Credential object with:
        Username = ClientId
        Password = ClientSecret
        
    -ClientId <String>
        ClientId to authenticate with
        
    -ClientSecret <String>
        ClientSecret to authenticate with
        
    -AuthBody <Hashtable>
        Extra auth body - required by some endpoints to get access to resources
        
    -ReturnToken [<SwitchParameter>]
        Return token as string
        
    -ReturnHeader [<SwitchParameter>]
        Return hashtable that can be used by Invoke-RestMethod and Invoke-WebRequest
        
    -ReturnResponse [<SwitchParameter>]
        Return full response recieved from server
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Connect-OAuth2 -Uri "$uri/auth/token" -ClientCredential aaaa -ClientSecret bbbb -AuthBody @{scope = 'all'}
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Invoke-RestMethod -Uri "$uri/api/Info" -Headers (Connect-OAuth2 -Uri "$uri/auth/token" -ClientCredential $cred -ReturnHeader)
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Connect-OAuth2 -examples".
    For more information, type: "get-help Connect-OAuth2 -detailed".
    For technical information, type: "get-help Connect-OAuth2 -full".

```



