# プライベート認証局を構築する

## CA証明書の取得
```powershell
docker cp certificate-authority:/etc/ssl/root_ca/certs/root_ca.crt .
docker cp certificate-authority:/etc/ssl/inter_ca/certs/inter_ca.crt .
```

## サーバー証明書の生成と取得
```powershell
docker exec certificate-authority sh -c 'SERVER_PASSWORD=password DN=apps.localdomain SUBJECT=/C=JP/CN=$DN SAN=DNS:$DN,DNS:app1.apps.localdomain generate_server && generate_crl'

docker cp certificate-authority:/etc/ssl/inter_ca/certs/apps.localdomain.crt .
```
