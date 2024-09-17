
##
## Run this on LXC Guest
##

### Install GPU support
# Update Repos
apt-get update && \
        apt-get -y upgrade -o Dpkg::Options::="--force-confold" && \
        apt-get -y dist-upgrade -o Dpkg::Options::="--force-confold" && \
        apt-get -y install --no-install-recommends software-properties-common

### Install CUDA & CUDNN
# Install exactly the same driver version you installed on host
# https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#prepare-debian
# https://pve.proxmox.com/wiki/Developer_Workstations_with_Proxmox_VE_and_X11#Optional:_NVidia_Drivers
# https://docs.nvidia.com/deeplearning/cudnn/install-guide/index.html
# https://gist.github.com/kmhofmann/cee7c0053da8cc09d62d74a6a4c1c5e4

wget https://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/cuda-keyring_1.0-1_all.deb && \
        dpkg -i cuda-keyring_1.0-1_all.deb && \
        add-apt-repository non-free && \
        add-apt-repository contrib && \
        apt update && apt full-upgrade && \
        apt install -y cuda && \
        apt install -y libcudnn8-dev
