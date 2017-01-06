#!/bin/bash

read -p "echo your domain:" SET_DOMAIN;
#read -p "echo your domain:" SET_NAME;

echo "your setting is ${SET_DOMAIN}";
#echo "your setting is ${SET_NAME}";


#openssl genrsa 4096 > ${SET_DOMAIN}.key

#rm -rf  /home/www/ssl/${SET_DOMAIN}/
mkdir -pv /home/www/ssl/${SET_DOMAIN}/challenges/ && chown www:www -R /home/www/ssl/${SET_DOMAIN}
cd /home/www/ssl/${SET_DOMAIN}/

openssl genrsa 4096 > account.key

# 方式1
#openssl genrsa 4096 > ${SET_DOMAIN}.key
#openssl req -new -sha256 -key ${SET_DOMAIN}.key -out ${SET_DOMAIN}.csr

# 方式2
openssl genrsa 4096 > ${SET_DOMAIN}.key
openssl req -new -sha256 -key ${SET_DOMAIN}.key -nodes -out ${SET_DOMAIN}.csr -subj "/C=CN/ST=GuangZhou/L=GuangZhou/O=LKS Inc./OU=Web Security/CN=${SET_DOMAIN}"


# 方式3
#openssl req -new -newkey rsa:4096 -sha256 -nodes -out ${SET_DOMAIN}.csr -keyout ${SET_DOMAIN}.key -subj "/C=CN/ST=GuangZhou/L=GuangZhou/O=LKS Inc./OU=Web Security/CN=${SET_DOMAIN}"

wget https://raw.githubusercontent.com/diafygi/acme-tiny/master/acme_tiny.py
python3 acme_tiny.py --account-key ./account.key --csr ./${SET_DOMAIN}.csr --acme-dir /home/www/ssl/${SET_DOMAIN}/challenges/ > ./signed.crt
#python3 acme_tiny.py --account-key ./ssl.hk.laikansha.com.key --csr ./ssl.hk.laikansha.com.csr --acme-dir /home/www/ssl/ssl.hk.laikansha.com/challenges/ > ./signed.crt


wget -O - https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem > intermediate.pem
cat signed.crt intermediate.pem > chained.pem
wget -O - https://letsencrypt.org/certs/isrgrootx1.pem > root.pem
cat intermediate.pem root.pem > full_chained.pem
# mkdir -pv /home/www/ssl/ssl.hk.laikansha.com/challenges/ && chown www:www -R /home/www/ssl/ssl.hk.laikansha.com


cat >>renew_cert.sh<<EOF
#!/bin/bash

cd /home/www/ssl/${SET_DOMAIN}/
python3 acme_tiny.py --account-key account.key --csr ${SET_DOMAIN}.csr --acme-dir /home/www/ssl/${SET_DOMAIN}/challenges/ > signed.crt || exit
wget -O - https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem > intermediate.pem
cat signed.crt intermediate.pem > chained.pem
service nginx reload
EOF

chmod +x renew_cert.sh

echo "Your SSL DIR IN: /home/www/ssl/${SET_DOMAIN}/ And Dir Filse:"
ls -l /home/www/ssl/${SET_DOMAIN}/

echo "You Should Add this setting to your nginx conf like this:"
echo '=========================================================='

echo "listen 443;"
echo "ssl on;"
echo "ssl_certificate     /home/www/ssl/${SET_DOMAIN}/chained.pem;"
echo "ssl_certificate_key /home/www/ssl/${SET_DOMAIN}/${SET_DOMAIN}.key;"
echo ""
echo "ssl_protocols TLSv1.2 TLSv1.1 TLSv1; "
echo "ssl_ciphers FIPS@STRENGTH:!aNULL:!eNULL; "
echo "ssl_prefer_server_ciphers on; "
echo "ssl_stapling on; "
echo "ssl_stapling_verify on; "
echo "add_header Strict-Transport-Security \"max-age=31536000;includeSubDomains\";"

echo '=========================================================='