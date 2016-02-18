#Documentation https://azure.microsoft.com/en-us/documentation/articles/vpn-gateway-howto-point-to-site-rm-ps/
#Working with self-signed root certificates for Point-to-Site configurations https://azure.microsoft.com/en-us/documentation/articles/vpn-gateway-certificates-point-to-site/

# To login to Azure Resource Manager
Login-AzureRmAccount

# Get a list of your Azure subscriptions
Get-AzureRmSubscription

# Specify the subscription that you want to use
Select-AzureRmSubscription -SubscriptionName "[SubscriptionName]"

#Configuration
$VNetName  = "[VNetName]"
$SubName = "[SubnetName]"
$GWSubName = "GatewaySubnet"
$VNetPrefix1 = "[VNetAddress/Mask]"
$SubPrefix = "[SubnetAddress/Mask]"
$GWSubPrefix = "[GatewaySubnetAddress/Mask]"
$VPNClientAddressPool = "[VPNSubnetAddress/Mask]"
$RG = "[RGName]"
$Location = "[LocationName]"
$DNS = "[DNSIP]"
$GWName = "[GatewayName]"
$GWIPName = "[GatewayIPName]"
$GWIPconfName = "[GatewayConfName]"
$P2SRootCertName = "[CertificateName.cer]"

#----------------------NEW DEPLOYMENT----------------------
# Create a new resource group
New-AzureRmResourceGroup -Name $RG -Location $Location

# Create the subnet configurations for the virtual network
$sub = New-AzureRmVirtualNetworkSubnetConfig -Name $SubName -AddressPrefix $SubPrefix
$gwsub = New-AzureRmVirtualNetworkSubnetConfig -Name $GWSubName -AddressPrefix $GWSubPrefix

# Create the virtual network
New-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $RG -Location $Location -AddressPrefix $VNetPrefix1 -Subnet $sub, $gwsub -DnsServer $DNS

# Specify the variables for the virtual network you just created
$vnet = Get-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $RG
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet

# Request a dynamically assigned public IP address
$pip = New-AzureRmPublicIpAddress -Name $GWIPName -ResourceGroupName $RG -Location $Location -AllocationMethod Dynamic
$ipconf = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName -Subnet $subnet -PublicIpAddress $pip

# Upload a root certificate .cer file to Azure
$MyP2SRootCertPubKeyBase64 = "[Certificate Data]"
$p2srootcert = New-AzureRmVpnClientRootCertificate -Name $P2SRootCertName -PublicCertData $MyP2SRootCertPubKeyBase64

# Create the virtual network gateway for your VNet
New-AzureRmVirtualNetworkGateway -Name $GWName -ResourceGroupName $RG -Location $Location -IpConfigurations $ipconf -GatewayType Vpn -VpnType RouteBased -EnableBgp $false -GatewaySku Standard -VpnClientAddressPool $VPNClientAddressPool -VpnClientRootCertificates $p2srootcert

# Download the VPN client configuration package
Get-AzureRmVpnClientPackage -ResourceGroupName $RG -VirtualNetworkGatewayName $GWName -ProcessorArchitecture Amd64

#----------------------EXISTING DEPLOYMENT----------------------
#Get Gateway
$gw = Get-AzureRmVirtualNetworkGateway -ResourceGroupName $RG -Name $GWName

#Create client VPN
Set-AzureRmVirtualNetworkGatewayVpnClientConfig -VirtualNetworkGateway $gw -VpnClientAddressPool $VPNClientAddressPool
 
# Create Root Cert
$MyP2SRootCertPubKeyBase64 = "[Certificate Data]"
$rootCert = Add-AzureRmVpnClientRootCertificate -VpnClientRootCertificateName $P2SRootCertName -PublicCertData $MyP2SRootCertPubKeyBase64 -VirtualNetworkGatewayName $GWName -ResourceGroupName $RG
 
# Download the VPN client configuration package
Get-AzureRmVpnClientPackage -ResourceGroupName $RG -VirtualNetworkGatewayName $GWName -ProcessorArchitecture Amd64