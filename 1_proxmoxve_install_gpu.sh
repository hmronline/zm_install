##
## Run this on Proxmox Host
## PromoxVE 7.2
##

### Install GPU
# https://pve.proxmox.com/wiki/Developer_Workstations_with_Proxmox_VE_and_X11#Optional:_NVidia_Drivers
add-apt-repository non-free && \
        apt-get update && \
        apt-get -y pve-headers && \
        apt-get -y install nvidia-legacy-390xx-driver
        #apt-get -y install nvidia-driver # this is for newer gpu cards
        #apt-get -y install nvidia-smi nvidia-cuda-toolkit

# Config GPU
echo -e "nvidia-drm\nnvidia\nnvidia_uvm" > /etc/modules-load.d/nvidia.conf
cat EOF > /etc/udev/rules.d/70-nvidia.rules
# Create /nvidia0, /dev/nvidia1 … and /nvidiactl when nvidia module is loaded
KERNEL=="nvidia", RUN+="/bin/bash -c '/usr/bin/nvidia-smi -L && /bin/chmod 666 /dev/nvidia*'"
# Create the CUDA node when nvidia_uvm CUDA module is loaded
KERNEL=="nvidia_uvm", RUN+="/bin/bash -c '/usr/bin/nvidia-modprobe -c0 -u && /bin/chmod 0666 /dev/nvidia-uvm*'"
EOF

# Reboot Proxmox Host

# Run nvidia-smi and check GPU is properly detected

# Check GPU Architecture version as explained here: 
# https://pyimagesearch.com/2020/02/03/how-to-use-opencvs-dnn-module-with-nvidia-gpus-cuda-and-cudnn/

# Mine es 2.1, so update this variable set on 5_lxc_install_opencv.sh:
export CUDA_ARCH_BIN=2.1
