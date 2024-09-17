##
## Run this on Proxmox Host
##

### Doc
# https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#prepare-debian
# https://docs.nvidia.com/deeplearning/cudnn/install-guide/index.html

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
apt-get -y install pve-headers && \
        apt-get -y install cuda && \
        apt-get -y install libcudnn9-dev-cuda-12

### Config GPU Support
echo -e "nvidia\nnvidia_uvm\nnvidia_drm" > /etc/modules-load.d/nvidia.conf
cat > /etc/udev/rules.d/70-nvidia.rules <<EOF
# Create /nvidia0, /dev/nvidia1 … and /nvidiactl when nvidia module is loaded
KERNEL=="nvidia", RUN+="/bin/bash -c '/usr/bin/nvidia-smi -L && /bin/chmod 666 /dev/nvidia*'"
# Create the CUDA node when nvidia_uvm CUDA module is loaded
KERNEL=="nvidia_uvm", RUN+="/bin/bash -c '/usr/bin/nvidia-modprobe -c0 -u && /bin/chmod 0666 /dev/nvidia-uvm*'"
EOF

### Get GPU Architecture Version
# Check GPU Architecture version as explained here (in Step #5): 
# https://pyimagesearch.com/2020/02/03/how-to-use-opencvs-dnn-module-with-nvidia-gpus-cuda-and-cudnn/

# Mine es 7.5, so update this variable export on 6_lxc_install_opencv.sh:
export CUDA_ARCH_BIN=7.5

### Reboot Proxmox Host
