
##
## Run this on LXC Guest
##

# Verify CUDA is now supported in FFMPEG
/usr/bin/ffmpeg -hwaccels

# look for something like this:
# Hardware acceleration methods:
# vdpau
# cuda
# vaapi
# qsv
# drm
# opencl
# vulkan


# You will be now able to configure monitors with CUDA support
