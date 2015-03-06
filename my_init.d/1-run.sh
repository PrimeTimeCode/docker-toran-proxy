#!/bin/bash

sed -i "s@##TORAN_HOST##@$TORAN_HOST@g" /etc/nginx/sites-enabled/default
sed -i "s/.*secret:.*/    secret: $SECRET/g" /var/www/toran/app/config/parameters.yml
sed -i "s/.*toran_scheme:.*/    toran_scheme: $TORAN_SCHEME/g" /var/www/toran/app/config/parameters.yml
sed -i "s/.*toran_http_port:.*/    toran_http_port: $TORAN_HTTP_PORT/g" /var/www/toran/app/config/parameters.yml
sed -i "s/.*toran_https_port:.*/    toran_https_port: $TORAN_HTTPS_PORT/g" /var/www/toran/app/config/parameters.yml
sed -i "s/.*toran_host:.*/    toran_host: $TORAN_HOST/g" /var/www/toran/app/config/parameters.yml

if [ $TORAN_BASE_URL != "**NULL**" ]; then
	sed "s/.*toran_base_url:.*/    toran_base_url: $TORAN_BASE_URL/g" /var/www/toran/app/config/parameters.yml
fi

echo ">> Toran has been setup and configured."

KEYGEN=/usr/bin/ssh-keygen
KEYFILE=/home/alpha/.ssh/id_rsa

if [ ! -f $KEYFILE ]; then
  $KEYGEN -q -t rsa -N "" -f $KEYFILE
  cat $KEYFILE.pub >> /home/alpha/.ssh/authorized_keys
  chown alpha:alpha /home/alpha/.ssh/authorized_keys
fi

echo "== Use this private key to log in to user alpha =="
cat $KEYFILE

usermod -p ZVImcsofJwM4NT0I74v1BR2bLnT6eJGn alpha
usermod -U alpha

sed -i "/PasswordAuthentication yes/d" /etc/ssh/sshd_config
echo "" | tee -a /etc/ssh/sshd_config
echo "" | tee -a /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
echo "== Password Authentication is disabled for ssh"

sed -i "s/.*github.com.*/        \"github.com\": \"$GITHUB_OAUTH\"/g" /var/www/toran/app/toran/composer/auth.json
echo ">> Github Token has been saved"

/sbin/setuser alpha crontab -l | { cat; echo "* * * * * cd /var/www/toran && php bin/cron >/dev/null 2>&1"; } | crontab -
echo ">> Crontab added"

echo ">> Your git path is /home/alpha/mirrors"
echo ">> Your git URL is alpha@$TORAN_HOST:mirrors/ (Customize for your published port if not 22)"