$ContainerName = 'certificate-authority';

$password = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR(
  [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR(
    (Read-Host -Prompt "Password" -AsSecureString)
  )
);

$C = Read-Host -Prompt "C (Country [2-letter code], default is 'JP')";
if ([string]::IsNullOrEmpty($C)) {
  $C = 'JP';
}

$ST = Read-Host -Prompt "ST (State or Province)";
if ([string]::IsNullOrEmpty($ST)) {
  $ST = '';
}

$L = Read-Host -Prompt "L ((City or Locality)";
if ([string]::IsNullOrEmpty($L)) {
  $L = '';
}

$O = Read-Host -Prompt "O (Organization)";
if ([string]::IsNullOrEmpty($O)) {
  $O = '';
}

$OU = Read-Host -Prompt "OU (Organization Unit)";
if ([string]::IsNullOrEmpty($OU)) {
  $OU = '';
}

$CN = Read-Host -Prompt "CN (Common Name, ex. www.example.com)";
if ([string]::IsNullOrEmpty($CN)) {
  throw "Common Name (CN) must not be empty."
}

$subAltName = Read-Host -Prompt "Subject Alternative Name (!!! Do NOT specify ""DNS:$CN"" !!!, ex. DNS:www.example.com,DNS:mail.example.com,IP:12.34.56.78)";
if ([string]::IsNullOrEmpty($subAltName)) {
  $subAltName = '';
}

$command  = "SERVER_PASSWORD='$password' ";
$command += "DN='$CN' ";
$command += "SUBJECT='";
if (![string]::IsNullOrEmpty($C)) {
  $command += "/C=$C";
}
if (![string]::IsNullOrEmpty($ST)) {
  $command += "/ST=$ST";
}
if (![string]::IsNullOrEmpty($L)) {
  $command += "/L=$L";
}
if (![string]::IsNullOrEmpty($O)) {
  $command += "/O=$O";
}
if (![string]::IsNullOrEmpty($OU)) {
  $command += "/OU=$OU";
}
$command += "/CN=$CN' ";
$command += "SAN='DNS:$CN";
if (![string]::IsNullOrEmpty($subAltName)) {
  $command += ",$subAltName";
}
$command += "' ";
$command += "generate_server && generate_crl";

docker exec "$ContainerName" sh -c "$command";


$privateKeyFilePath = $ContainerName + ':/etc/ssl/inter_ca/private/' + $CN + '.nopass.pem';
docker cp "$privateKeyFilePath" .;

$certFilePath = $ContainerName + ':/etc/ssl/inter_ca/certs/' + $CN + '.crt';
docker cp "$certFilePath" .;

$certChainFilePath = $ContainerName + ':/etc/ssl/inter_ca/certs/' + $CN + '.chain.crt';
docker cp "$certChainFilePath" .;
