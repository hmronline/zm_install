##
## Run this on Proxmox Host
## PromoxVE 7.2
##

### Install GPU
# https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#prepare-debian
# https://pve.proxmox.com/wiki/Developer_Workstations_with_Proxmox_VE_and_X11#Optional:_NVidia_Drivers
wget https://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/cuda-keyring_1.0-1_all.deb && \
        sudo dpkg -i cuda-keyring_1.0-1_all.deb && \
        add-apt-repository non-free && \
        add-apt-repository contrib && \
        apt-get update && \
        apt-get -y pve-headers && \
        apt-get -y install cuda

# Config GPU
echo -e "nvidia\nnvidia_uvm\nnvidia_drm" > /etc/modules-load.d/nvidia.conf
cat > /etc/udev/rules.d/70-nvidia.rules <<EOF
# Create /nvidia0, /dev/nvidia1 … and /nvidiactl when nvidia module is loaded
KERNEL=="nvidia", RUN+="/bin/bash -c '/usr/bin/nvidia-smi -L && /bin/chmod 666 /dev/nvidia*'"
# Create the CUDA node when nvidia_uvm CUDA module is loaded
KERNEL=="nvidia_uvm", RUN+="/bin/bash -c '/usr/bin/nvidia-modprobe -c0 -u && /bin/chmod 0666 /dev/nvidia-uvm*'"
EOF

# Reboot Proxmox Host

# Run nvidia-smi and check GPU is properly detected

# Check GPU Architecture version as explained here (in Step #5): 
# https://pyimagesearch.com/2020/02/03/how-to-use-opencvs-dnn-module-with-nvidia-gpus-cuda-and-cudnn/

# Mine es 7.5, so update this variable set on 6_lxc_install_opencv.sh:
export CUDA_ARCH_BIN=7.5
