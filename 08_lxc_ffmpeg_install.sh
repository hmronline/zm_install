
##
## Run this on LXC Guest
##

export DEBIAN_VERSION=bookworm

### Install FFMPEG with required CUDA support

# Install repo https://www.deb-multimedia.org/
wget https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2016.8.1_all.deb && \
    dpkg -i deb-multimedia-keyring_2016.8.1_all.deb && \
    echo "deb https://www.deb-multimedia.org ${DEBIAN_VERSION} main non-free" > /etc/apt/sources.list.d/02_deb-multimedia.list

# Add APT policy for conflicting repos
cat > /etc/apt/preferences.d/zm-policy <<EOF
Package: *
Pin: origin zmrepo.zoneminder.com
Pin-Priority: 1001

Package: zoneminder
Pin: origin www.deb-multimedia.org
Pin-Priority: -1
EOF

# Update repos
apt-get update && \
    apt-get -y full-upgrade

# Install ffmpeg
apt-get -y install libnvidia-encode1 ffmpeg
