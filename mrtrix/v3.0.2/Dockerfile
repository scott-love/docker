################################################################################
# Get a working version of MRtrix3.0.2
# FSL 6.0.4 & ANTs v2.3.4 are also installed
# NOTE: I have not checked all the functionality of these 3 softwares.
################################################################################

ARG DEBIAN_VERSION=buster
ARG BASE_PYTHON_VERSION=3.8
ARG ANTs_VERSION=v2.3.4
ARG MRTRIX_VERSION=3.0.2

# Use an official Python runtime as a parent image
FROM python:${BASE_PYTHON_VERSION}-slim-${DEBIAN_VERSION}

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    curl \
    libquadmath0 \
    git-core \
    cmake \
    g++ \
    zlib1g-dev \
    bc \
    build-essential \
    dc \
    libopenblas-dev \
    nano \
    nodejs \
    perl-modules \
    tar \
    tcsh \
    unzip \
    wget \
    libeigen3-dev \
    libfftw3-dev \
    libtiff5-dev \
    zlib1g-dev \
  && apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y

# Specify where to install packages:
ENV INSTALL_FOLDER=/usr/local/

###   Install FSL 6.0.4  ###
# Exclude atlases, gpu stuff, etc
RUN curl -sSL https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-6.0.4-centos7_64.tar.gz | tar xz -C ${INSTALL_FOLDER} \
    --exclude='fsl/doc' \
    --exclude='fsl/data/first' \
    --exclude='fsl/data/atlases' \
    --exclude='fsl/data/possum' \
    --exclude='fsl/src' \
    --exclude='fsl/extras/src' \
    --exclude='fsl/bin/fslview*' \
    --exclude='fsl/bin/FSLeyes' \
    --exclude='fsl/bin/*_gpu*' \
    --exclude='fsl/bin/*_cuda*'

# Configure fsl environment
ENV FSLDIR=${INSTALL_FOLDER}/fsl/ \
        FSLOUTPUTTYPE=NIFTI_GZ
ENV PATH=${FSLDIR}/bin:$PATH \
      LD_LIBRARY_PATH=${FSLDIR}:${LD_LIBRARY_PATH}

# Specify where to install packages:
ENV ANTS_FOLDER=/usr/local/ANTs

# Grab the Github repository, checkout the needed version,
#   build
ARG ANTs_VERSION
RUN cd /tmp && \
    git clone https://github.com/ANTsX/ANTs.git && \
    cd ANTs && \
    git checkout ${ANTs_VERSION} && \
    buildDir=${PWD}/build && \
    mkdir -p $buildDir ${ANTS_FOLDER} && \
    cd $buildDir && \
    cmake \
        -DCMAKE_INSTALL_PREFIX=${ANTS_FOLDER} \
              -DBUILD_SHARED_LIBS=OFF \
      	-DSuperBuild_ANTS_USE_GIT_PROTOCOL=OFF \
              -DBUILD_TESTING=OFF \
              -DRUN_LONG_TESTS=OFF \
              -DRUN_SHORT_TESTS=OFF \
              /tmp/ANTs 2>&1 | tee cmake.log && \
make 2>&1 | tee build.log && \
cd ${buildDir}/ANTS-build && \
make install 2>&1 | tee install.log && \
rm -r /tmp/ANTs

# Add ANTs/bin to the path:
ENV PATH=$ANTS_FOLDER/bin/:$PATH

# MRtrix3 setup
# Commit checked out is 3.0_RC3 tag with subsequent hotfixes as at 14/12/2018
RUN git clone https://github.com/MRtrix3/mrtrix3.git mrtrix3 && \
    cd mrtrix3 && \
    git checkout ${MRTRIX_VERSION} && \
    python configure -nogui && \
    python build -persistent -nopaginate && \
    git describe --tags > /mrtrix3_version

# Setup environment variables for MRtrix3
ENV PATH=/mrtrix3/bin:$PATH
ENV PYTHONPATH=/mrtrix3/lib:$PYTHONPATH


ENTRYPOINT ["/bin/bash"]
