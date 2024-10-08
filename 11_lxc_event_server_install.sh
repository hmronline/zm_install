
##
## Run this on LXC Guest
##

### Info
# https://www.reddit.com/r/ZoneMinder/comments/gvxvni/zoneminder_and_zmeventnotification_with_gpu/

### Install Event Server (ES)

## Install Dependencies
apt-get update && \
        apt-get -y install git libcrypt-mysql-perl libcrypt-eksblowfish-perl libconfig-inifiles-perl \
                libmodule-build-perl libyaml-perl make libjson-perl liblwp-protocol-https-perl \
                python3-future && \
        perl -MCPAN -e "force install Net::WebSocket::Server" && \
        perl -MCPAN -e "force install Net::MQTT::Simple" && \
        perl -MCPAN -e "force install Net::MQTT::Simple::Auth" && \
        pip3 install -U imutils --no-cache-dir --break-system-packages && \
        pip3 install -U pyzm --no-cache-dir --break-system-packages && \
        cd /root/

## Get ZM Event Server
cd /root/ && \
        rm -rf /root/zmeventnotification
        git clone https://github.com/zoneminder/zmeventnotification.git && \
        cd zmeventnotification && \
        #git fetch --tags && \
        #git checkout $(git describe --tags $(git rev-list --tags --max-count=1)) && \
        cd /root/

## Configure
# Edit zmeventnotification.ini as described in documentation
# I've disabled FCM and SSL, and enabled MQTT
sed -i "/^[ \t]*\[fcm\]/,/^\[/{s/\(^[ \t]*[^#; \t]*enable[ \t]*=\).*/\1no/}" /root/zmeventnotification/zmeventnotification.ini
sed -i "/^[ \t]*\[ssl\]/,/^\[/{s/\(^[ \t]*[^#; \t]*enable[ \t]*=\).*/\1no/}" /root/zmeventnotification/zmeventnotification.ini
sed -i "/^[ \t]*\[mqtt\]/,/^\[/{s/\(^[ \t]*[^#; \t]*enable[ \t]*=\).*/\1yes/}" /root/zmeventnotification/zmeventnotification.ini

## Debian 12 FIX
# THIS MIGHT BREAK PYTHON
rm /usr/lib/python3.*/EXTERNALLY-MANAGED

## Install
# Say Y to everything
cd /root/zmeventnotification && \
        ./install.sh --no-interactive --install-es --install-config --install-hook && \
        cd /root/

## Set permissions
mkdir -p /var/lib/zmeventnotification/images && \
        chown -R www-data:www-data /var/lib/zmeventnotification/

## Finalize
cd /root/ && \
        rm -rf /root/zmeventnotification

# yolo fix
# https://forums.zoneminder.com/viewtopic.php?t=32223

# Edit objectconfig.ini, zmeventserver.ini and secrets.ini as described in documentation
# https://zmeventnotification.readthedocs.io/en/latest/guides/install.html#update-the-configuration-files
