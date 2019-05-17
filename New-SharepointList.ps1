Function New-SharepointList {
    param (
        [parameter(Mandatory = $true, Helpmessage = "Titel voor de List")]
        $Title,
        [parameter(Mandatory = $true, Helpmessage = "Description van de List")]
        $Description,
        [parameter(Mandatory = $true, HelpMessage = "SiteURL.. bijvoorbeeld: dylanberghuis.sharepoint.com/sites/Demosite")]
        $SiteURL,
        [parameter(Mandatory = $true, HelpMessage = "Admin URL voor SPO-Connect PNP Provisioning")]
        $AdminURL,
        [parameter(Mandatory = $true, HelpMessage = "bijv 101 voor document library: https://docs.microsoft.com/en-us/previous-versions/office/sharepoint-server/ee541191(v%3Doffice.15)")]
        $Template
    )
    BEGIN {
        $CREDS = Get-Credential -Message "Global Admin of Sharepoint Admin creds SVP"
        try {
            Connect-SpoService -Url $AdminURL -Credential $CREDS
        }
        catch {
            Throw "Kon geen verbinding maken met site."
        }
    }
    PROCESS {
        Try {
            ## Building sharepoint creds
            $Sharepointcreds = New-Object Microsoft.Sharepoint.SharepointOnlineCredentials($CREDS)
            Write-Verbose "Sharepoint Creds gebuild"
            ##building connection
            $SharepointConnection = New-Object Microsoft.Sharepoint.Client.ClientContext($SiteURL)
            Write-Verbose "Connection gebuild"
            $SharepointConnection.Credentials = $Sharepointcreds
            ## Create list object
            $ListObject = New-Object Microsoft.Sharepoint.Client.ListCreationInformation
            $ListObject.Title = $Title
            $ListObject.Description = $Description
            $ListObject.TemplateType = $Template
            $add = $SharepointConnection.Web.Lists.Add($ListObject)
            $SharepointConnection.Load($add)
            Write-Verbose 'Listobject word gepusht'
            try {
                $SharepointConnection.executeQuery()
                Write-Host "Connection geBuild! "
            }
            catch{
                Throw "Connection kon niet gebuild worden.."
                Write-Verbose "Info: $($_.Exception.Message)"
            }
        }
        catch {
            Throw "Er is iets misgegaan met het opbouwen van de connectie, gebruik -Verbose voor verbose messages"
        }

    }
}