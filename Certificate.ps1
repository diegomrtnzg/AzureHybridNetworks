#Documentation https://azure.microsoft.com/en-us/documentation/articles/vpn-gateway-certificates-point-to-site/

cd "C:\Program Files (x86)\Windows Kits\10\bin\x64"

# create and install a root certificate in the Personal certificate store on your computer
.\makecert -sky exchange -r -n "CN=RootCertificateName" -pe -a sha1 -len 2048 -ss My "RootCertificateName.cer"

# generate a client certificate from a self-signed root certificate
.\makecert.exe -n "CN=ClientCertificateName" -pe -sky exchange -m 96 -ss My -in "RootCertificateName" -is my -a sha1

#Export with certmgr.msc