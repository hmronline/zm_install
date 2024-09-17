
##
## Run this on LXC Guest
##

export DEBIAN_VERSION=bookworm

### Install FFMPEG with required CUDA support

# Install repo https://www.deb-multimedia.org/
wget https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2016.8.1_all.deb && \
    dpkg -i deb-multimedia-keyring_2016.8.1_all.deb && \
    echo "deb https://www.deb-multimedia.org ${DEBIAN_VERSION} main non-free" > /etc/apt/sources.list.d/02_deb-multimedia.list && \
    apt update && apt -y full-upgrade && \
    apt -y install libnvidia-encode1 ffmpeg

