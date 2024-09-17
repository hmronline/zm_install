
##
## Run this on LXC Guest
##

# Info
# https://www.reddit.com/r/ZoneMinder/comments/gvxvni/zoneminder_and_zmeventnotification_with_gpu/

### Install Event Server (ES)

# Install Dependencies
apt-get update && \
        apt install -y git libcrypt-mysql-perl libcrypt-eksblowfish-perl libconfig-inifiles-perl \
                libmodule-build-perl libyaml-perl make libjson-perl liblwp-protocol-https-perl && \
        perl -MCPAN -e "force install Net::WebSocket::Server" && \
        perl -MCPAN -e "force install Net::MQTT::Simple" && \
        perl -MCPAN -e "force install Net::MQTT::Simple::Auth"

# Install
# Say Y to everything
git clone https://github.com/zoneminder/zmeventnotification.git && \
        cd zmeventnotification && \
        git fetch --tags && \
        git checkout $(git describe --tags $(git rev-list --tags --max-count=1)) && \
        ./install.sh && \
        cd ˜

# Set permissions
mkdir -p /var/lib/zmeventnotification/images && \
        chown -R www-data:www-data /var/lib/zmeventnotification/

# Test
# sudo -u www-data /var/lib/zmeventnotification/bin/zm_event_start.sh <eid> <mid> # replace www-data with apache if needed
# sudo -u www-data /var/lib/zmeventnotification/bin/zm_detect.py --config /etc/zm/objectconfig.ini  --eventid <eid> --monitorid <mid> --debug
