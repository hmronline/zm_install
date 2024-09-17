
##
## Run this on LXC Guest
##

export CUDA_ARCH_BIN=7.5
export OPENCV_VER=4.7.0 # 4.x

# Test
# Make sure OpenCV works:
# After you install opencv, make sure it works. 
# Start python3 and inside the interpreter, do a import cv2. 
# If it seg faults, you have a problem with the package you installed. 
# Like I said, I’ve never had issues after building from source.
# Note that if you get an error saying cv2 not found that means you did not install it in a place python3 can find it 
# (you might have installed it for python2 by mistake)

# Make sure no error are shown when training faces
sudo -u www-data /var/lib/zmeventnotification/bin/zm_train_faces.py
