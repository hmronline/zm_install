
##
## Run this on LXC Guest
##

### Install Event Server (ES)

# Install Dependencies
apt-get update && \
        apt install -y libcrypt-mysql-perl libcrypt-eksblowfish-perl libconfig-inifiles-perl \
                libmodule-build-perl libyaml-perl make libjson-perl liblwp-protocol-https-perl && \
        perl -MCPAN -e "force install Net::WebSocket::Server" && \
        perl -MCPAN -e "force install Net::MQTT::Simple" && \
        perl -MCPAN -e "force install Net::MQTT::Simple::Auth"

# Install
git clone https://github.com/zoneminder/zmeventnotification.git && \
        cd zmeventnotification && \
        git fetch --tags && \
        git checkout $(git describe --tags $(git rev-list --tags --max-count=1)) && \
        ./install.sh

