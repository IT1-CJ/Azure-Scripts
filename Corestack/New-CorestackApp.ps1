# =============================================================
# Corestack Enterprise App Creation Script
# Author:       Christopher Johnston
# Organisation: IT1 Source
# Contact:      christopher.johnston@it1.com
# Description:  Creates an Enterprise App (Service Principal),
#               exports credentials to JSON, and assigns Reader
#               role across all subscriptions automatically
# =============================================================

# ---- Configuration ----
Connect-AzureAD -TenantId ""
$tenantId = ""
$appName = "ReaderApp"
$secretValue = ""

# ---- Create App Registration with Secret ----
$startDate = Get-Date
$endDate = $startDate.AddYears(1)
$pwdCred = @{
    DisplayName   = "$appName-Secret"
    StartDateTime = $startDate
    EndDateTime   = $endDate
    SecretText    = $secretValue
}

$app = New-AzADApplication -DisplayName $appName -PasswordCredential @($pwdCred)
Start-Sleep -Seconds 60

# ---- Create Service Principal ----
$sp = New-AzADServicePrincipal -ApplicationId $app.AppId
Start-Sleep -Seconds 60

# ---- Export Credentials to JSON ----
$tenantId = (Get-AzContext).Tenant.Id
$subscriptionId = (Get-AzContext).Subscription.Id

$appInfo = @{
    ClientId       = $app.AppId
    ClientSecret   = $secretValue
    TenantId       = $tenantId
    SubscriptionId = $subscriptionId
}

$appInfo | ConvertTo-Json | Out-File -FilePath "C:\ReaderAppCredentials.json"
Write-Host "Credentials exported to C:\ReaderAppCredentials.json"

# ---- Get Service Principal Object ID ----
$sp1 = Get-AzADServicePrincipal -DisplayName $appName
$spObjectId = $sp1.Id

# ---- Automatically Pull All Subscriptions ----
Write-Host "Fetching all subscriptions..."
$subscriptions = Get-AzSubscription -TenantId $tenantId

# ---- Assign Reader Role to All Subscriptions ----
foreach ($subscription in $subscriptions) {
    Write-Host "-> Assigning Reader to: $($subscription.Name) ($($subscription.Id))"

    $scope = "/subscriptions/" + $subscription.Id
    Set-AzContext -SubscriptionId $subscription.Id -ErrorAction Continue

    New-AzRoleAssignment `
        -ObjectId $spObjectId `
        -RoleDefinitionName "Reader" `
        -Scope $scope `
        -ErrorAction Continue
}

Write-Host "========================================"
Write-Host " IT1 Source - Corestack App Creation Complete!"
Write-Host "========================================"