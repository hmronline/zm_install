
##
## Run this on LXC Guest
##

### Info
# https://zoneminder.readthedocs.io/en/latest/installationguide/ubuntu.html#easy-way-ubuntu-18-04-bionic
# https://www.reddit.com/r/ZoneMinder/comments/gvxvni/zoneminder_and_zmeventnotification_with_gpu/

# https://gist.github.com/minhlucnd/d97600b4e3cd31d964a4e8607e19a50a
# https://medium.com/@MARatsimbazafy/journey-to-deep-learning-nvidia-gpu-passthrough-to-lxc-container-97d0bc474957
# https://pyimagesearch.com/2020/02/03/how-to-use-opencvs-dnn-module-with-nvidia-gpus-cuda-and-cudnn/
# https://www.reddit.com/r/ZoneMinder/comments/gvxvni/zoneminder_and_zmeventnotification_with_gpu/


export ZM_VERS='1.36'
export TZ='America/Argentina/Buenos_Aires'
export ZM_DB_USER='zmuser'
export ZM_DB_PASS='zmpass'

### Install ZoneMinder

## Step 1: Update Repos
# Add ZoneMinder repo
echo "deb https://zmrepo.zoneminder.com/debian/release-${ZM_VERS} "`lsb_release  -c -s`"/" | sudo tee /etc/apt/sources.list.d/01_zoneminder.list
wget -O - https://zmrepo.zoneminder.com/debian/archive-keyring.gpg | sudo apt-key add -
read -p "Warning! Check above to insure the line says OK. If not the GPG signing key was not installed and you will need to figure out why before continuing." nothing

# Update repos
apt-get update && \
        apt-get -y upgrade -o Dpkg::Options::="--force-confold" && \
        apt-get -y dist-upgrade -o Dpkg::Options::="--force-confold" && \
        apt-get -y install --no-install-recommends software-properties-common && \
        apt-get -y install apt-transport-https lsb-release gnupg gnupg2 && \
        apt-get -y autoremove

## Step 2: Install Dependencies & Related
apt-get -y install nginx nginx-extras php-fpm fcgiwrap && \
        export PHP_VERS=$(php --version | head -1 | cut -d' ' -f2 | cut -d'.' -f1-2) && \
        sed -i "s|^;cgi.fix_pathinfo=.*|cgi.fix_pathinfo=1|" /etc/php/$PHP_VERS/fpm/php.ini && \
        systemctl restart php$PHP_VERS-fpm
        apt-get -y install mariadb-server php-mysql && \
        mysql_secure_installation && \
        systemctl restart mysql && \
        apt-get -y install ssmtp mailutils net-tools wget curl sudo make && \
        apt-get -y install libcrypt-mysql-perl libyaml-perl libjson-perl libavutil-dev && \
        apt-get -y install --no-install-recommends libvlc-dev libvlccore-dev vlc

## Step 3: Install ZoneMinder
apt-get -y install zoneminder zoneminder-doc --no-install-recommends && \
apt-get -y remove apache2 && \
sed -i 's|^ZM_PATH_FFMPEG="/usr/bin/ffmpeg"|ZM_PATH_FFMPEG="/usr/bin/ffmpeg -hwaccel cuda"|' /etc/zm/conf.d/01-system-paths.conf

## Step 4: Configure MySQL
rm /etc/mysql/my.cnf && \
        cp /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/my.cnf && \
        service mysql restart

## Step 5: Configure nginx
cat > /etc/nginx/zoneminder.conf <<EOF
location /zm/cgi-bin {
        gzip off;
        auth_basic off;
        alias /usr/lib/zoneminder/cgi-bin;     
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$request_filename;
        #fastcgi_param SCRIPT_FILENAME /usr/lib/zoneminder/cgi-bin/nph-zms;
        fastcgi_intercept_errors on;
        fastcgi_param HTTP_PROXY "";
        fastcgi_pass unix:/var/run/fcgiwrap.socket;
}
location /zm/cache {
        auth_basic off;
        alias /var/cache/zoneminder/cache;
}
location ~ /zm/api/(css|img|ico) {
        auth_basic off;
        rewrite ^/zm/api(.+)$ /api/app/webroot/\$1 break;
        try_files \$uri \$uri/ =404;
}

location /zm {
        gzip off;
        auth_basic off;
        alias /usr/share/zoneminder/www;
        index index.php;
        try_files \$uri \$uri/ /index.php?\$args =404;    

        location /zm/api {
                auth_basic off;
                rewrite ^/zm/api(.+)$ /zm/api/app/webroot/index.php?p=\$1 last;
        }
        location ~ \.php$ {
                include fastcgi_params;
                fastcgi_param SCRIPT_FILENAME \$request_filename;
                fastcgi_param HTTP_PROXY "";
                fastcgi_index index.php;
                fastcgi_intercept_errors on;
                fastcgi_pass unix:/var/run/php/php$PHP_VERS-fpm.sock;
        }
}

location ~* /zm/.*\.(txt|log)$ {
        deny all;
}

EOF

sed -i "s|^.*index index.html index.htm index.nginx-debian.html;|index index.php index.html index.htm index.nginx-debian.html;|" /etc/nginx/sites-available/default
sed -i "s|^include /etc/nginx/zoneminder.conf;||" /etc/nginx/sites-available/default
sed -i "s|^.*# include snippets/snakeoil.conf;|# include snippets/snakeoil.conf;\ninclude /etc/nginx/zoneminder.conf;|" /etc/nginx/sites-available/default

## Step 6: Configure PHP
sed -i 's|^FCGI_CHILDREN="1"|FCGI_CHILDREN="10"|' /etc/init.d/fcgiwrap

# 30 is the number of cameras
echo "DAEMON_OPTS=-c 30" > /etc/default/fcgiwrap
systemctl restart fcgiwrap

# Set TimeZone
# https://github.com/ZoneMinder/zoneminder/issues/2565
timedatectl set-timezone ${TZ}

## Step 7: Set permissions
chmod 740 /etc/zm/zm.conf && \
        chown root:www-data /etc/zm/zm.conf && \
        chown -R www-data:www-data /usr/share/zoneminder/

## Step 8: zmaudit
echo '#!/bin/sh' > /etc/cron.weekly/zmaudit && \
        echo -e "\n/usr/bin/zmaudit.pl -f" >> /etc/cron.weekly/zmaudit && \
        chmod +x /etc/cron.weekly/zmaudit

## Step 9: DB Fix
zmupdate.pl -f

## Step 10: Start services
systemctl enable zoneminder && \
        systemctl restart zoneminder && \
        systemctl restart nginx

