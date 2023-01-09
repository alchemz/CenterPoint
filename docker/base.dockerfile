FROM nvcr.io/nvidia/pytorch:21.10-py3
ARG TORCH_CUDA_ARCH_LIST="5.2 6.0 6.1 7.0 7.5+PTX"
ENV DEBIAN_FRONTEND=noninteractive

### Install CMake
RUN apt-get update \
 && apt-get -V install -y software-properties-common wget \
 && wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/nullsoftware-properties-common \
 && apt-add-repository 'deb https://apt.kitware.com/ubuntu/ focal main' \
 && apt-get -V install -y cmake

### Install apx, already has apx
# COPY apex /code/apex
# WORKDIR /code/apex
# RUN pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./
# install spconv
RUN pip install spconv-cu114

### Install LLVM 10
WORKDIR /code
RUN http_proxy=http://19.12.80.237:83/ wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh && ./llvm.sh 10

### OpenPCDet dependencies fail to install unless LLVM 10 exists on the system
# and there is a llvm-config binary available, so we have to symlink it here.
RUN ln -s /usr/bin/llvm-config-10 /usr/bin/llvm-config

### Install CenterPoint
COPY CenterPoint /code/CenterPoint
WORKDIR /code/CenterPoint
RUN pip install -r requirements.txt
RUN bash setup.sh
RUN chmod -R +777 /code 

### Install waymo open dataset kit
RUN pip install tensorflow-gpu==2.6.0 \
    install waymo-open-dataset-tf-2-6-0 --user \
    pip install pandas==1.1.1 --user \

WORKDIR /code/CenterPoint
ENV PYTHONPATH "${PYTHONPATH}:/code/CenterPoint"