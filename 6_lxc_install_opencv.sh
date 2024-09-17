
##
## Run this on LXC Guest
##

# https://pyimagesearch.com/2020/02/03/how-to-use-opencvs-dnn-module-with-nvidia-gpus-cuda-and-cudnn/

export CUDA_ARCH_BIN=7.5

### Install OpenCV
# https://docs.opencv.org/4.x/d7/d9f/tutorial_linux_install.html
# https://github.com/opencv/opencv/issues/22132
# https://forums.developer.nvidia.com/t/opencv-building-with-cuda-cudnn-no-cudnn/174228
# https://github.com/opencv/opencv/issues/16380

# Install dependencies
# This requires about 20GB RAM and 10 CPU Cores to build dlib
apt-get update && \
        apt install -y cmake g++ wget unzip python3-dev python3-pip && \
        apt install -y build-essential cmake unzip pkg-config && \
        apt install -y libjpeg-dev libpng-dev libtiff-dev && \
        apt install -y libavcodec-dev libavformat-dev libswscale-dev && \
        apt install -y libv4l-dev libxvidcore-dev libx264-dev && \
        apt install -y libgtk-3-dev && \
        apt install -y libatlas-base-dev gfortran python3-dev && \
        apt install -y libcudnn8 libcudnn8-dev && \
        pip3 install -U pip && \
        pip3 install -U numpy && \
        pip3 install face_recognition

sudo apt-get install cmake git libgtk2.0-dev pkg-config
sudo apt install libavcodec-dev libavformat-dev libswscale-dev libavresample-dev
$ sudo apt install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
$ sudo apt install libxvidcore-dev x264 libx264-dev libfaac-dev libmp3lame-dev libtheora-dev 
$ sudo apt install libfaac-dev libmp3lame-dev libvorbis-dev
apt install libopencore-amrnb-dev libopencore-amrwb-dev
sudo apt install python3-testresources
apt-get install libtbb-dev

apt install libdc1394-dev libdc1394-25 libdc1394-22-dev
apt-get install libxine2-dev libv4l-dev v4l-utils
cd /usr/include/linux && ln -s ../libv4l1-videodev.h videodev.h && cd -

# Download and unpack sources
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.x.zip && \
        wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.x.zip && \
        unzip opencv.zip && \
        unzip opencv_contrib.zip

# Configure
# make sure you set the CUDA_ARCH_BIN variable based on your NVIDIA GPU architecture version
rm -rf /root/build && mkdir -p /root/build && cd /root/build && \
        cmake -v -D CMAKE_BUILD_TYPE=RELEASE \
                -D CMAKE_CONFIGURATION_TYPES=RELEASE \
                -D CMAKE_INSTALL_PREFIX=/usr/local \
                -D WITH_TBB=ON \
                -D OPENCV_ENABLE_NONFREE=ON \
                -D WITH_CUDA=ON \
                -D WITH_CUDNN=ON \
                -D OPENCV_DNN_CUDA=ON \
                -D CUDA_ARCH_BIN=${CUDA_ARCH_BIN} \
                -D ENABLE_FAST_MATH=1 \
                -D CUDA_FAST_MATH=1 \
                -D WITH_CUBLAS=1 \
                -D OPENCV_EXTRA_MODULES_PATH=/root/opencv_contrib-4.x/modules \
                -D BUILD_NEW_PYTHON_SUPPORT=ON \
                -D BUILD_opencv_cudacodec=OFF \
                -D BUILD_opencv_python3=ON \
                -D HAVE_opencv_python3=ON \
                -D BUILD_OPENCV_WORLD=ON \
                -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
                -D PYTHON_EXECUTABLE=$(which python3) \
                -D PYTHON2_EXECUTABLE=$(which python2) \
                -D PYTHON3_PACKAGES_PATH=/usr/lib/python3/dist-packages \
                -D BUILD_EXAMPLES=OFF \
                -D BUILD_TESTS=OFF \
                -D BUILD_PERF_TESTS=OFF \
                -D INSTALL_PYTHON_EXAMPLES=OFF \
                -D INSTALL_C_EXAMPLES=OFF \
                ../opencv-4.x

# Build (this may take a while)
cd /root/build && \
        cmake --build . && \
        make install && \
        cd /root/

# Test
# Make sure OpenCV works:
# After you install opencv, make sure it works. 
# Start python3 and inside the interpreter, do a import cv2. 
# If it seg faults, you have a problem with the package you installed. 
# Like I said, I’ve never had issues after building from source.
# Note that if you get an error saying cv2 not found that means you did not install it in a place python3 can find it 
# (you might have installed it for python2 by mistake)
