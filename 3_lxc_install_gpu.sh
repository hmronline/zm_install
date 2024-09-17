
##
## Run this on LXC Guest
##

### Install GPU support

# Step 1: Update Repos
add-apt-repository non-free && \
        apt-get update && \
        apt-get -y upgrade -o Dpkg::Options::="--force-confold" && \
        apt-get -y dist-upgrade -o Dpkg::Options::="--force-confold" && \
        apt-get -y install --no-install-recommends software-properties-common

# Install exactly the same driver version you installed on host
# In my case:

### Install GPU
# https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#prepare-debian
# https://pve.proxmox.com/wiki/Developer_Workstations_with_Proxmox_VE_and_X11#Optional:_NVidia_Drivers
wget https://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb

add-apt-repository non-free && \
        add-apt-repository contrib && \
        apt-get update && \
        apt-get -y pve-headers && \
        apt-get -y install nvidia-legacy-390xx-driver && \
        #apt-get -y install nvidia-driver && \ # this is for newer gpu cards
        #apt-get -y install nvidia-smi nvidia-cuda-toolkit && \
        apt-get -y install cuda && \
        apt-get -y install cuda-nvcc-11-6

# Run nvidia-smi and check GPU is properly detected

# Run nvcc --version
