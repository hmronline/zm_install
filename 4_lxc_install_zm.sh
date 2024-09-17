
##
## Run this on LXC Guest
##

# Info
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

# Step 1: Update Repos
apt-get update && \
        apt-get -y upgrade -o Dpkg::Options::="--force-confold" && \
        apt-get -y dist-upgrade -o Dpkg::Options::="--force-confold" && \
        apt-get -y install --no-install-recommends software-properties-common && \
        apt-get -y install apt-transport-https gnupg

echo "deb https://zmrepo.zoneminder.com/debian/release-1.36 bullseye/" | sudo tee /etc/apt/sources.list.d/zoneminder.list 
wget -O - https://zmrepo.zoneminder.com/debian/archive-keyring.gpg | sudo apt-key add -

apt-get update && \
        apt-get -y upgrade -o Dpkg::Options::="--force-confold" && \
        apt-get -y dist-upgrade -o Dpkg::Options::="--force-confold"

# Step 2: Install Dependencies & Related
apt-get update && \
        apt-get -y install mariadb-server && \
        apt-get -y install ssmtp mailutils net-tools wget curl sudo make && \
        apt-get -y install apache2 php-fpm && \
        apt-get -y install libcrypt-mysql-perl libyaml-perl libjson-perl libavutil-dev && \
        apt-get -y install --no-install-recommends libvlc-dev libvlccore-dev vlc

# Step 3: Install ZoneMinder
apt-get -y install zoneminder

# Step 4: Configure MySQL
rm /etc/mysql/my.cnf && \
        cp /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/my.cnf && \
        service mysql restart

# Step 5: Configure Apache & PHP
export PHP_VERS=$(php --version | head -1 | cut -d' ' -f2 | cut -d'.' -f1-2)
adduser www-data video && \
        a2dissite 000-default && \
        a2dismod mpm_prefork mpm_worker && \
        #a2dismod mpm_event && \
        #a2enmod cgi && \
        a2enmod mpm_event setenvif proxy_fcgi && \
        a2enmod ssl rewrite expires headers && \
        echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
        sed -i "s|^;date.timezone =.*|date.timezone = ${TZ}|" /etc/php/$PHP_VERS/fpm/php.ini && \
        #sed -i "s|^;date.timezone =.*|date.timezone = ${TZ}|" /etc/php/$PHP_VERS/apache2/php.ini && \
        a2enconf php$PHP_VERS-fpm 
        a2enconf zoneminder

# Step 6: Set permissions
chmod 740 /etc/zm/zm.conf && \
        chown root:www-data /etc/zm/zm.conf && \
        chown -R www-data:www-data /usr/share/zoneminder/ && \
        mkdir -p /var/lib/zmeventnotification/images && \
        chown -R www-data:www-data /var/lib/zmeventnotification/

# Step 7: zmaudit
echo '#!/bin/sh' > /etc/cron.weekly/zmaudit && \
        echo -e "\n/usr/bin/zmaudit.pl -f" >> /etc/cron.weekly/zmaudit && \
        chmod +x /etc/cron.weekly/zmaudit

# Step 8: DB Fix
zmupdate.pl -f

# Step 9: Start services
systemctl enable zoneminder && \
        systemctl start zoneminder && \
        systemctl reload apache2

# Step 10: Making sure ZoneMinder works
ZM_INSTALLED_VERS=$(curl http://localhost/zm/api/host/getVersion.json -q 2>/dev/null|grep version|cut -d'"' -f4|cut -d'.' -f1-2)
echo -e "INSTALLED: ${ZM_INSTALLED_VERS}"

