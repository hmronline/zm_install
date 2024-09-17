
##
## Run this on LXC Guest
##

## Test
# Make sure OpenCV works:
# Start python3 and inside the interpreter, do a import cv2. 
# If it seg faults, you have a problem with the package you installed. 
# Like I said, I’ve never had issues after building from source.
# Note that if you get an error saying cv2 not found that means you did not install it in a place python3 can find it 
# (you might have installed it for python2 by mistake)

# Make sure no errors are shown when training faces
sudo -u www-data /var/lib/zmeventnotification/bin/zm_train_faces.py
