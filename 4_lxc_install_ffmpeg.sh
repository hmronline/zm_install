
##
## Run this on LXC Guest
##

### Install FFMPEG with required CUDA support

# Install repo https://www.deb-multimedia.org/
wget https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2016.8.1_all.deb
dpkg -i deb-multimedia-keyring_2016.8.1_all.deb
echo 'deb https://www.deb-multimedia.org bullseye main non-free' > /etc/apt/sources.list.d/deb-multimedia.list

apt-get update && \
    apt-get full-upgrade && \
    apt -y install libnvidia-encode1

# Verify CUDA is now supported
/usr/bin/ffmpeg -hwaccels

# You will be now able to configure monitors with CUDA support
