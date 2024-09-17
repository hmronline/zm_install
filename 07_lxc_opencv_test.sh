
##
## Run this on LXC Guest
##

## Test
# Make sure OpenCV works:
# If it fails, you have a problem with the package you installed. 

cat > /root/opencv_test.py <<EOF
import cv2

print("OpenCV version:", cv2.__version__)
EOF


cd /root/ && \
    python3 /root/opencv_test_py && \
    rm /root/opencv_test.py

