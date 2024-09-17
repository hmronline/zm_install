##
## Run this on Proxmox Host
##

# Run nvidia-smi and check GPU is properly detected

nvidia-smi

# Something like this:

# root@pve:~# nvidia-smi
# Mon Sep 16 20:03:46 2024       
# +-----------------------------------------------------------------------------------------+
# | NVIDIA-SMI 560.35.03              Driver Version: 560.35.03      CUDA Version: 12.6     |
# |-----------------------------------------+------------------------+----------------------+
# | GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
# | Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
# |                                         |                        |               MIG M. |
# |=========================================+========================+======================|
# |   0  NVIDIA GeForce GTX 1650        On  |   00000000:01:00.0 Off |                  N/A |
# |  0%   40C    P8             N/A /   75W |       1MiB /   4096MiB |      0%      Default |
# |                                         |                        |                  N/A |
# +-----------------------------------------+------------------------+----------------------+
                                                                                         
# +-----------------------------------------------------------------------------------------+
# | Processes:                                                                              |
# |  GPU   GI   CI        PID   Type   Process name                              GPU Memory |
# |        ID   ID                                                               Usage      |
# |=========================================================================================|
# |  No running processes found                                                             |
# +-----------------------------------------------------------------------------------------+
# root@pve:~# 
