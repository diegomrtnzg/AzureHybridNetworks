# Installing Azure PowerShell from the Gallery
# Install the Azure Resource Manager modules from the PowerShell Gallery
Install-Module AzureRM
Install-AzureRM

# Install the Azure Service Management module from the PowerShell Gallery
Install-Module Azure

# Import AzureRM modules for the given version manifest in the AzureRM module
Import-AzureRM

# Import Azure Service Management module
Import-Module Azure

#--------------------------------------
# Commands to help you get started
# To make sure the Azure PowerShell module is available after you install
Get-Module –ListAvailable 

# If the Azure PowerShell module is not listed when you run Get-Module, you may need to import it
Import-Module Azure 

# To login to Azure Resource Manager
Login-AzureRmAccount

# You can also use a specific Tenant if you would like a faster login experience
# Login-AzureRmAccount -TenantId xxxx

# To view all subscriptions for your account
Get-AzureRmSubscription

# To select a default subscription for your current session
Get-AzureRmSubscription –SubscriptionName “your sub” | Select-AzureRmSubscription

# View your current Azure PowerShell session context
# This session state is only applicable to the current session and will not affect other sessions
Get-AzureRmContext

# To select the default storage context for your current session
Set-AzureRmCurrentStorageAccount –ResourceGroupName “your resource group” –StorageAccountName “your storage account name”

# View your current Azure PowerShell session context
# Note: the CurrentStorageAccount is now set in your session context
Get-AzureRmContext

# To import the Azure.Storage data plane module (blob, queue, table)
Import-Module Azure.Storage

# To list all of the blobs in all of your containers in all of your accounts
Get-AzureRmStorageAccount | Get-AzureStorageContainer | Get-AzureStorageBlob