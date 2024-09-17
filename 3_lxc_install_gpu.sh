
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

apt-get update && \
        apt-get -y install nvidia-legacy-390xx-driver

# Run nvidia-smi and check GPU is properly detected

wget https://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
sudo add-apt-repository contrib
sudo apt-get update
sudo apt-get -y install cuda

# Run nvcc --version
