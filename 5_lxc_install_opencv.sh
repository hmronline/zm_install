
##
## Run this on LXC Guest
##

export CUDA_ARCH_BIN=2.1

### Install OpenCV
# https://docs.opencv.org/4.x/d7/d9f/tutorial_linux_install.html

# Install dependencies
apt-get update && \
        apt install -y cmake g++ wget unzip python3-dev python3-pip && \
        apt install -y libatlas-base-dev gfortran && \
        pip3 install -U pip && \
        pip3 install -U numpy && \
        pip3 install face_recognition

# Download and unpack sources
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.x.zip && \
        wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.x.zip && \
        unzip opencv.zip && \
        unzip opencv_contrib.zip
        

# Configure
# make sure you set the CUDA_ARCH_BIN variable based on your NVIDIA GPU architecture version
rm -rf /root/build && mkdir -p /root/build && cd /root/build && \
        cmake -v -D CMAKE_BUILD_TYPE=RELEASE \
                -D CMAKE_INSTALL_PREFIX=/usr/local \
                -D INSTALL_PYTHON_EXAMPLES=OFF \
                -D INSTALL_C_EXAMPLES=OFF \
                -D OPENCV_ENABLE_NONFREE=ON \
                -D WITH_CUDA=OFF \
                -D WITH_CUDNN=OFF \
                -D OPENCV_DNN_CUDA=OFF \
                -D CUDA_ARCH_BIN=${CUDA_ARCH_BIN} \
                -D ENABLE_FAST_MATH=1 \
                -D CUDA_FAST_MATH=1 \
                -D WITH_CUBLAS=1 \
                -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib-4.x/modules \
                -D HAVE_opencv_python3=ON \
                -D PYTHON_EXECUTABLE=$(which python3) \
                -D BUILD_EXAMPLES=OFF \
                ../opencv-4.x

# Build
cd /root/build && \
        cmake --build . && \
        make install && \
        cd /root/



# Info
# https://www.reddit.com/r/ZoneMinder/comments/gvxvni/zoneminder_and_zmeventnotification_with_gpu/
# https://pyimagesearch.com/2020/02/03/how-to-use-opencvs-dnn-module-with-nvidia-gpus-cuda-and-cudnn/
