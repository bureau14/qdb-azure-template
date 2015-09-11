$ErrorActionPreference = "Stop"
$resourceGroupName = "qdbtestcluster"
Set-PSDebug -Trace 1
# Add-AzureAccount 
Select-AzureSubscription -SubscriptionName "MSDN"
Switch-AzureMode -Name AzureResourceManager
New-AzureResourceGroup -Location westeurope -ResourceGroupName $resourceGroupName
New-AzureResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile .\azuredeploy.json -TemplateParameterFile .\azuredeploy-parameters.json –Verbose
Get-AzurePublicIpAddress -ResourceGroupName $resourceGroupName | Select IpAddress