$ErrorActionPreference = "Stop"
Set-PSDebug -Trace 1
Select-AzureSubscription -SubscriptionName "MSDN"
Remove-AzureResourceGroup qdbtestcluster -Force -Verbose