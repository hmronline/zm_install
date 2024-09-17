# Install ZoneMinder on ProxmoxVE with EventServer and GPU support

## Host
* Hardware (just as reference):
  * Intel(R) Core(TM) i7-10700F CPU
  * 64 GB RAM
  * NVIDIA GeForce GTX 1650
* Proxmox VE 8.x (Debian 12 Bookworm)

## Guest
* LXC Container
* 14 Cores
* 20 GB RAM
* 30 GB disk
* Additional 20 GB Mount Point for /var/cache/zoneminder/
* Debian 12 (Bookworm)

## ZoneMinder
* version 1.36.x
* nginx WebServer
* EventServer with GPU (CUDA) support
* ffmpeg with GPU (CUDA) support
* HomeAssistant with MQTT integration
