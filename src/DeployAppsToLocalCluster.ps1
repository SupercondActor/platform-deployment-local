### deploy apps to local dev cluster

#!!! PARAMETERS: ======================================================================

# Active Directory App Registration Name - for authenticatioin
#  (if not provided will be generated from cluster name):
$azureAdAppName = ""

# End of the parameters section ========================================================


### Variables for common values

# current folder
$path = $PSScriptRoot
if([string]::IsNullOrEmpty($path))
{
    Write-Host "Can't get this script file path." -ForegroundColor Red
    Write-Host "Press Enter to exit"
    Read-Host
    return
}
$managerPackagePath = Join-Path $path "ManagerPackage"
$servicePackagePath = Join-Path $path "ServicePackage"

### Connect to AZURE
#Connect-AzureRmAccount

$allSubs = Get-AzureRmSubscription
if($allSubs.Count -eq 1)
{
    $subscription = $allSubs[0]
}
else
{
    Write-Host ("Found " + $allSubs.Count + " available Azure subscriptions.") -ForegroundColor Yellow
    for($i=0; $i -lt $allSubs.Count; $i++)
    {
        Write-Host ($i.ToString() + " - " + $allSubs[$i].Name)
    }
    Write-Host ("Enter a number to select the one you need (Ctrl+C to exit):") -ForegroundColor Yellow
    $nbr = Read-Host
    $subscription = $allSubs[$nbr]
    if($subscription)
    {
        Write-Host ("Selected subscriptioin: '" + $subscription.Name + "'") -ForegroundColor Green
        Select-AzureRmSubscription -SubscriptionId $subscription.Id
    }
    else
    {
        Write-Host ("No subscription selected.") -ForegroundColor Red
        Write-Host "Press Enter to exit"
        Read-Host
        return
    }
}

### Create Azure AD Application Registration for authentication
Write-Host "Creating Azure AD Application Registration for authentication..." -ForegroundColor Yellow

$homeUri = "https://localhost"
$replyUrls = $homeUri, ($homeUri + "/*")

if([string]::IsNullOrEmpty($azureAdAppName))
{
    $azureAdAppName = ("SupercondActor-auth-local")
}
$appUri = ("https://" + $azureAdAppName)

$azureAdApp = Get-AzureRmADApplication -DisplayName $azureAdAppName
$newAzureAdApp = $false
if($azureAdApp)
{

     Write-Host ("Found existing Application Registration for " + $azureAdApp.DisplayName + ". Updating Reply URLs...")
     foreach($rpUrl in $replyUrls)
     {
        if($azureAdApp.ReplyUrls.Contains($rpUrl))
        {
             Write-Host ("Url " + $rpUrl + " exists.")
        }
        else
        {
             Write-Host ("Adding url " + $rpUrl + " ...")
             $azureAdApp.ReplyUrls.Add($rpUrl);
             $azureAdApp | Update-AzureRmADApplication -ReplyUrl $azureAdApp.ReplyUrls | Out-Null
        }
     }
}
else
{   
    Write-Host ("Creating Application Registration " + $azureAdApp.DisplayName + " ...")
    $azureAdApp = New-AzureRmADApplication -DisplayName $azureAdAppName -HomePage $homeUri -IdentifierUris $appUri -ReplyUrls $replyUrls
    $newAzureAdApp = true
}

Write-Host ("Application Name: " + $azureAdAppName)
Write-Host ("Application Id: " + $azureAdApp.ApplicationId.Guid)
Write-Host ("Tenant Id: " + $subscription.TenantId)

$appParams = @{"SupercondActor.Platform.WebManager_AuthClientID" = $azureAdApp.ApplicationId.Guid.ToString(); "SupercondActor.Platform.WebManager_AuthTenantID" = $subscription.TenantId}

Write-Host ((Get-Date -Format T) + " - Azure AD Application Registration complete.") -ForegroundColor Green


### Deploy application package
Write-Host "Deploying Manager application package..." -ForegroundColor Yellow

# Connect to the cluster using a client certificate.
$clusterInfo = Connect-ServiceFabricCluster localhost:19000

$managerAppName = "SupercondActor.Platform.WebManagerApp"
$managerAppType = "SupercondActor.Platform.WebManagerAppType"
$managerInstanceName = ("fabric:/" + $managerAppName)

# Copy the application package to the cluster image store.
Copy-ServiceFabricApplicationPackage $managerPackagePath -ApplicationPackagePathInImageStore $managerAppName -ShowProgress

# Register the application type.
Register-ServiceFabricApplicationType -ApplicationPathInImageStore $managerAppName

# Remove the application package to free system resources.
Remove-ServiceFabricApplicationPackage -ApplicationPackagePathInImageStore $managerAppName

# Create the application instance.
New-ServiceFabricApplication -ApplicationName $managerInstanceName -ApplicationTypeName $managerAppType -ApplicationTypeVersion 1.0.0 -ApplicationParameter $appParams

Write-Host ((Get-Date -Format T) + " - Manager application package deployed.") -ForegroundColor Green
Write-Host "Deploying Service application package..." -ForegroundColor Yellow

$serviceAppName = "SupercondActor.Platform.BusinessServicesApp"
$serviceAppType = "SupercondActor.Platform.BusinessServicesAppType"
$serviceInstanceName = ("fabric:/" + $serviceAppName + ".01")

# Copy the application package to the cluster image store.
Copy-ServiceFabricApplicationPackage $servicePackagePath -ApplicationPackagePathInImageStore $serviceAppName -ShowProgress

# Register the application type.
Register-ServiceFabricApplicationType -ApplicationPathInImageStore $serviceAppName

# Remove the application package to free system resources.
Remove-ServiceFabricApplicationPackage -ApplicationPackagePathInImageStore $serviceAppName

# Create the application instance.
New-ServiceFabricApplication -ApplicationName $serviceInstanceName -ApplicationTypeName $serviceAppType -ApplicationTypeVersion 1.0.0


Write-Host ((Get-Date -Format T) + " - All done!") -ForegroundColor Green
Write-Host ""
Write-Host "Business Platform Manager URL:"
Write-Host ("https://localhost/service-manager") -ForegroundColor Magenta
Write-Host ""
Write-Host ("Cluster Manager URL (open in Chrome and select certificate '$subname'):")
Write-Host ("http://localhost:19080")
Write-Host ""

if($newAzureAdApp)
{
    Write-Host "IMPORTANT:" -ForegroundColor Red
    Write-Host ("Set Required Permissions for your App Registation '" + $azureAdAppName + "' in Azure Portal!") -ForegroundColor Yellow
    Write-Host "Navigate to:" -ForegroundColor Yellow
    Write-Host ("https://portal.azure.com/#blade/Microsoft_AAD_IAM/ApplicationBlade/appId/$($azureAdApp.ApplicationId)/objectId/$($azureAdApp.ObjectId)") -ForegroundColor Magenta
    Write-Host "Click on 'Settings' > 'Required permissions' > 'Add' > 'Select an API' > 'Windows Azure Active Directory'" -ForegroundColor Yellow
    Write-Host "Click 'Select'" -ForegroundColor Yellow
    Write-Host "Set checkbox: 'Sign in and read user profile'" -ForegroundColor Yellow
    Write-Host "Click 'Select' and 'Done'" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "Press Enter to exit"
Read-Host
