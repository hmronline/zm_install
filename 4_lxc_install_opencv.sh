
##
## Run this on LXC Guest
##

export CUDA_ARCH_BIN=7.5
export OPENCV_VER=4.7.0 # 4.x

### Install OpenCV
# https://pyimagesearch.com/2020/02/03/how-to-use-opencvs-dnn-module-with-nvidia-gpus-cuda-and-cudnn/
# https://docs.opencv.org/4.x/d7/d9f/tutorial_linux_install.html
# https://github.com/opencv/opencv/issues/22132
# https://forums.developer.nvidia.com/t/opencv-building-with-cuda-cudnn-no-cudnn/174228
# https://github.com/opencv/opencv/issues/16380

# Install dependencies
apt-get update && \
        apt install -y g++ wget unzip python3-dev python3-pip python3-dev && \
        apt install -y build-essential cmake ninja-build && \
        apt install -y libtbb-dev && \
        apt install -y libatlas-base-dev gfortran  && \
        apt install -y libdc1394-dev libdc1394-25 libdc1394-22-dev && \
        apt install -y libavcodec-dev libavformat-dev libswscale-dev libavresample-dev && \
        apt install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev && \
        apt install -y libavdevice-dev libavfilter-dev libswresample-dev libavutil-dev  && \
        apt install -y libopenblas-dev liblapack-dev libblas-dev && \
        pip3 install -U pip && \
        pip3 install -U numpy --no-cache-dir

# Install Dlib and Face Recognition
cd /root/ && git clone https://github.com/davisking/dlib.git && \
        cd /root/dlib && mkdir build; cd build; cmake ..; cmake --build . && \
        cd /root/dlib && python3 setup.py install && \
        pip3 install -U face_recognition --no-cache-dir

#        pip3 install -U dlib --no-cache-dir && \

# Download and unpack sources
cd /root/ && \
        rm -rf opencv* && \
        wget -O opencv.zip https://github.com/opencv/opencv/archive/${OPENCV_VER}.zip && \
        rm -rf opencv_contrib* && \
        wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/${OPENCV_VER}.zip && \
        unzip opencv.zip && rm opencv.zip && \
        unzip opencv_contrib.zip && rm opencv_contrib.zip

# Configure
# make sure you set the CUDA_ARCH_BIN variable based on your NVIDIA GPU architecture version
rm -rf /root/build && mkdir -p /root/build && cd /root/build && rm -f CMakeCache.txt && \
        cmake -GNinja -v \
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

# Build (this may take a while)
cd /root/build && \
        ninja && \
        ninja install && \
        cd /root/

rm -rf /root/build && rm -rf /root/opencv-${OPENCV_VER} && rm -rf /root/opencv_contrib-${OPENCV_VER}

# Test
# Make sure OpenCV works:
# After you install opencv, make sure it works. 
# Start python3 and inside the interpreter, do a import cv2. 
# If it seg faults, you have a problem with the package you installed. 
# Like I said, I’ve never had issues after building from source.
# Note that if you get an error saying cv2 not found that means you did not install it in a place python3 can find it 
# (you might have installed it for python2 by mistake)
