
##
## Run this on LXC Guest
##

export DEBIAN_VERSION=debian12
export DEBIAN_ARCHITECTURE=x86_64

### Update Repos
wget https://developer.download.nvidia.com/compute/cuda/repos/${DEBIAN_VERSION}/${DEBIAN_ARCHITECTURE}/cuda-keyring_1.1-1_all.deb && \
        sudo dpkg -i cuda-keyring_1.1-1_all.deb && \
        rm cuda-keyring_1.1-1_all.deb && \
        apt-get -y install --no-install-recommends software-properties-common && \
        apt-add-repository -y contrib && \
        apt-get update && \
        apt-get -y full-upgrade

### Install GPU Support
apt-get -y install cuda && \
        apt-get -y install libcudnn9-dev-cuda-12

