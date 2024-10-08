
##
## Run this on LXC Guest
##

export CUDA_ARCH_BIN=7.5
export OPENCV_VER=4.10.0

### Doc
# https://pyimagesearch.com/2020/02/03/how-to-use-opencvs-dnn-module-with-nvidia-gpus-cuda-and-cudnn/
# https://docs.opencv.org/4.x/d7/d9f/tutorial_linux_install.html
# https://github.com/opencv/opencv/issues/22132
# https://forums.developer.nvidia.com/t/opencv-building-with-cuda-cudnn-no-cudnn/174228
# https://github.com/opencv/opencv/issues/16380
# https://www.reddit.com/r/ZoneMinder/comments/gvxvni/zoneminder_and_zmeventnotification_with_gpu/

## Install dependencies
apt-get update && \
        apt-get -y install g++ wget unzip python3-dev python3-pip python3-dev && \
        apt-get -y install build-essential cmake ninja-build && \
        apt-get -y install libtbb-dev && \
        apt-get -y install libatlas-base-dev gfortran  && \
        apt-get -y install libdc1394-dev libdc1394-25 && \
        apt-get -y install libavcodec-dev libavformat-dev libswscale-dev libavresample-dev && \
        apt-get -y install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev && \
        apt-get -y install libavdevice-dev libavfilter-dev libswresample-dev libavutil-dev  && \
        apt-get -y install libopenblas-dev liblapack-dev libblas-dev && \
        apt-get -y install libgstreamer-plugins-base1.0-0 && \
        pip3 install cmake --break-system-packages

## Install Dlib and Face Recognition
# https://forums.zoneminder.com/viewtopic.php?t=30064
# Had several issues (seg faults) trying to compile it under LXC host...
# After adding all dependencies on PVE host it compiled fine on the LXC host
cd /root/ && \
        rm -rf /root/dlib && \
        git clone https://github.com/davisking/dlib.git && \
        cd /root/dlib && \
        rm -rf build && \
        mkdir build && \
        cd build && \
        cmake .. && \
        cmake --build . && \
        cd /root/dlib && \
        python3 setup.py install --verbose --clean && \
        cd /root/ && \
        rm -rf /root/dlib

# Alternatives
# cd /root/dlib && python3 setup.py install --clean --no DLIB_USE_CUDA
#        pip3 install -U dlib --no-cache-dir --verbose

## Install Face Recognition
pip3 install -U face_recognition --no-cache-dir --break-system-packages

## Download and unpack sources
cd /root/ && \
        rm -rf opencv* && \
        wget -O opencv.zip https://github.com/opencv/opencv/archive/${OPENCV_VER}.zip && \
        rm -rf opencv_contrib* && \
        wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/${OPENCV_VER}.zip && \
        unzip opencv.zip && rm opencv.zip && \
        unzip opencv_contrib.zip && rm opencv_contrib.zip

## Configure
# make sure you set the CUDA_ARCH_BIN variable based on your NVIDIA GPU architecture version
rm -rf /root/build && \
        mkdir -p /root/build && \
        cd /root/build && \
        rm -f CMakeCache.txt && \
        cmake -GNinja \
                -D CMAKE_BUILD_TYPE=RELEASE \
                -D CMAKE_CONFIGURATION_TYPES=RELEASE \
                -D CMAKE_INSTALL_PREFIX=/usr/local \
                -D OPENCV_ENABLE_NONFREE=ON \
                -D OPENCV_DNN_CUDA=ON \
                -D CUDA_ARCH_BIN=${CUDA_ARCH_BIN} \
                -D ENABLE_FAST_MATH=1 \
                -D CUDA_FAST_MATH=1 \
                -D WITH_TBB=ON \
                -D WITH_CUDA=ON \
                -D WITH_CUDNN=ON \
                -D WITH_CUBLAS=ON \
                -D OPENCV_EXTRA_MODULES_PATH=/root/opencv_contrib-${OPENCV_VER}/modules \
                -D BUILD_opencv_cudacodec=OFF \
                -D BUILD_opencv_python3=ON \
                -D HAVE_opencv_python3=ON \
                -D BUILD_OPENCV_WORLD=ON \
                -D BUILD_NEW_PYTHON_SUPPORT=ON \
                -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
                -D PYTHON_EXECUTABLE=$(which python3) \
                -D PYTHON2_EXECUTABLE=$(which python2) \
                -D PYTHON3_PACKAGES_PATH=/usr/lib/python3/dist-packages \
                -D BUILD_EXAMPLES=OFF \
                -D BUILD_TESTS=OFF \
                -D BUILD_PERF_TESTS=OFF \
                -D INSTALL_PYTHON_EXAMPLES=OFF \
                -D INSTALL_C_EXAMPLES=OFF \
                /root/opencv-${OPENCV_VER}

## Build (this may take a while)
cd /root/build && \
        ninja && \
        ninja install && \
        cd /root/ && \
        rm -rf /root/build && \
        rm -rf /root/opencv-${OPENCV_VER} && \
        rm -rf /root/opencv_contrib-${OPENCV_VER}

