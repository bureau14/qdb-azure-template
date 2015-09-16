$ErrorActionPreference = "Stop"
#Add-AzureAccount

Select-AzureSubscription -SubscriptionName "MSDN"
Switch-AzureMode -Name AzureResourceManager
Remove-AzureResourceGroup qdbtestcluster -Force -Verbose

[Console]::Beep()