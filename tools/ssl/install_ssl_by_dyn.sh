#!/bin/bash

read -p "echo your domain:" SET_DOMAIN;
#read -p "echo your domain:" SET_NAME;

echo "your setting is ${SET_DOMAIN}";
#echo "your setting is ${SET_NAME}";

read -p "Setting the ssl Dir: (defaul as ${SET_SSLDIR})" SET_SSLDIR

if [[ "$SET_SSLDIR" == "" ]]; then
SET_SSLDIR="${SET_SSLDIR}"
fi

echo "Your SSL DIR is ${SET_SSLDIR}"
exit

echo "You should add this to your nginx conf before you run signed script:"
echo "location ^~ /.well-known/acme-challenge/ {"
echo "    alias ${SET_SSLDIR}/challenges/;"
echo "    try_files \$uri =404;"
echo "}"

read -p "Is add correct?(y or n)" ADD_STATUS

echo "You setting is: ${ADD_STATUS}"

if [[ "$ADD_STATUS" != "y" ]]; then
echo "you don't setting nginx conf!exit!"
exit
fi


#openssl genrsa 4096 > www.key
#rm -rf  ${SET_SSLDIR}/
mkdir -pv ${SET_SSLDIR}/challenges/ && chown www:www -R ${SET_SSLDIR}
cd ${SET_SSLDIR}/

openssl genrsa 4096 > account.key

# 方式1
#openssl genrsa 4096 > www.key
#openssl req -new -sha256 -key www.key -out www.csr

# 方式2
openssl genrsa 4096 > www.key
openssl req -new -sha256 -key www.key -nodes -out www.csr -subj "/C=CN/ST=GuangZhou/L=GuangZhou/O=LKS Inc./OU=Web Security/CN=${SET_DOMAIN}"


# 方式3
#openssl req -new -newkey rsa:4096 -sha256 -nodes -out www.csr -keyout www.key -subj "/C=CN/ST=GuangZhou/L=GuangZhou/O=LKS Inc./OU=Web Security/CN=${SET_DOMAIN}"

wget https://raw.githubusercontent.com/diafygi/acme-tiny/master/acme_tiny.py
python3 acme_tiny.py --account-key ./account.key --csr ./www.csr --acme-dir ${SET_SSLDIR}/challenges/ > ./signed.crt
#python3 acme_tiny.py --account-key ./ssl.hk.laikansha.com.key --csr ./ssl.hk.laikansha.com.csr --acme-dir /home/www/ssl/ssl.hk.laikansha.com/challenges/ > ./signed.crt


wget -O - https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem > intermediate.pem
cat signed.crt intermediate.pem > chained.pem
wget -O - https://letsencrypt.org/certs/isrgrootx1.pem > root.pem
cat intermediate.pem root.pem > full_chained.pem
# mkdir -pv /home/www/ssl/ssl.hk.laikansha.com/challenges/ && chown www:www -R /home/www/ssl/ssl.hk.laikansha.com


cat >>renew_cert.sh<<EOF
#!/bin/bash

cd ${SET_SSLDIR}/
python3 acme_tiny.py --account-key account.key --csr www.csr --acme-dir ${SET_SSLDIR}/challenges/ > signed.crt || exit
wget -O - https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem > intermediate.pem
cat signed.crt intermediate.pem > chained.pem
service nginx reload
EOF

chmod +x renew_cert.sh

echo "Your SSL DIR IN: ${SET_SSLDIR}/ And Dir Filse:"
ls ${SET_SSLDIR}/

echo "You Should Add this setting to your nginx conf like this:"
echo '#=========================================================='

echo "listen 443;"
echo "ssl on;"
echo "ssl_certificate     ${SET_SSLDIR}/chained.pem;"
echo "ssl_certificate_key ${SET_SSLDIR}/www.key;"
echo ""
echo "ssl_protocols TLSv1.2 TLSv1.1 TLSv1; "
echo "ssl_ciphers FIPS@STRENGTH:!aNULL:!eNULL; "
echo "ssl_prefer_server_ciphers on; "
echo "ssl_stapling on; "
echo "ssl_stapling_verify on; "
echo "add_header Strict-Transport-Security \"max-age=31536000;includeSubDomains\";"

echo '#=========================================================='

echo ""
echo ""

echo "Then add this to your crond (crontab -e ):"
echo '#===================================================================='
echo "0 0 2 * * ${SET_SSLDIR}/renew_cert.sh >/dev/null 2>&1"
echo '#===================================================================='