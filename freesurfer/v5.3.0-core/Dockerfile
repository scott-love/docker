
# FreeSurfer 5.3 core Docker image
#
# Build:
#   docker build --platform linux/amd64 \
#     --tag sclove/freesurfer5.3-core:latest .
#
# Example usage:
#   docker run --rm -ti \
#     --platform linux/amd64 \
#     -v /input/directory:/input \
#     -v /output/directory:/output \
#     sclove/freesurfer5.3-core:latest \
#     mri_convert -at /input/inputvolume.nii /output/outvolume.mgz

# Start with Ubuntu 14.04 (Trusty)
FROM ubuntu:trusty


# Install dependencies for FreeSurfer 5.3
RUN apt-get -o Acquire::Check-Valid-Until=false update \
    && apt-get install -y --no-install-recommends \
         tcsh \
         tar \
         wget \
         libgomp1 \
         perl-modules \
         bc \
    && rm -rf /var/lib/apt/lists/*



# Download and install FreeSurfer 5.3.0
RUN wget --tries=5 --timeout=60 \
      -O /tmp/freesurfer.tar.gz \
      https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/5.3.0/freesurfer-Linux-centos4_x86_64-stable-pub-v5.3.0.tar.gz \
    && echo "084d341cdf98305127aaeee48a6f4e0b  /tmp/freesurfer.tar.gz" \
      | md5sum -c - \
    && tar -xzf /tmp/freesurfer.tar.gz -C /opt \
    && rm /tmp/freesurfer.tar.gz \
    && rm -rf /opt/freesurfer/subjects/* \
    && rm -rf /opt/freesurfer/average/* \
    && rm -rf /opt/freesurfer/trctrain/* \
    && mkdir /output

# Configure license
COPY license /opt/freesurfer/.license


# Configure basic FreeSurfer environment
ENV OS=Linux \
    FS_OVERRIDE=0 \
    FIX_VERTEX_AREA= \
    SUBJECTS_DIR=/subjects \
    FSF_OUTPUT_FORMAT=nii.gz \
    MNI_DIR=/opt/freesurfer/mni \
    LOCAL_DIR=/opt/freesurfer/local \
    FREESURFER_HOME=/opt/freesurfer \
    FSFAST_HOME=/opt/freesurfer/fsfast \
    MINC_BIN_DIR=/opt/freesurfer/mni/bin \
    MINC_LIB_DIR=/opt/freesurfer/mni/lib \
    MNI_DATAPATH=/opt/freesurfer/mni/data \
    FMRI_ANALYSIS_DIR=/opt/freesurfer/fsfast \
    PERL5LIB=/opt/freesurfer/mni/lib/perl5/5.8.5 \
    MNI_PERL5LIB=/opt/freesurfer/mni/lib/perl5/5.8.5 \
    PATH=/opt/freesurfer/bin:/opt/freesurfer/fsfast/bin:/opt/freesurfer/tktools:/opt/freesurfer/mni/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Configure bashrc to source FreeSurferEnv.sh
RUN /bin/bash -c 'echo -e "source $FREESURFER_HOME/FreeSurferEnv.sh &>/dev/null" >> /root/.bashrc'
