$ErrorActionPreference = "Stop"

$resourceGroupName = "qdbtestcluster"
$templateFile = "$PSScriptRoot\azuredeploy.json"
$parametersFile = "$PSScriptRoot\azuredeploy-parameters.json"

#Add-AzureAccount 
Select-AzureSubscription -SubscriptionName "MSDN"
Switch-AzureMode -Name AzureResourceManager
New-AzureResourceGroup -Location eastasia -ResourceGroupName $resourceGroupName
New-AzureResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFile -TemplateParameterFile $parametersFile –Verbose
Get-AzurePublicIpAddress -ResourceGroupName $resourceGroupName | Select IpAddress

[Console]::Beep()