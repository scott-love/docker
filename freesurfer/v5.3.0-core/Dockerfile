
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


# Start with Ubuntu 14.04 (Trusty), pinned to a specific image digest
FROM ubuntu:trusty@sha256:64483f3496c1373bfd55348e88694d1c4d0c9b660dee6bfef5e12f43b9933b30

# Install dependencies for FreeSurfer 5.3
RUN apt-get -o Acquire::Check-Valid-Until=false update \
    && apt-get install -y --no-install-recommends \
         tcsh \
         tar \
         wget \
         libgomp1 \
         perl-modules \
         bc \
         patch \
         libglu1-mesa \
         libxmu6 \
         libgl1-mesa-glx \
         libxrender1 \
         libfontconfig1 \
         libglib2.0-0 \
         libxss1 \
         libxft2 \
         libjpeg62 \
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

# Apply local patch for conditional atlas preflight checks
COPY patches/0001-conditional-atlas-preflight.patch /tmp/0001-conditional-atlas-preflight.patch

RUN cd /opt/freesurfer/bin \
    && patch --batch --forward -p1 < /tmp/0001-conditional-atlas-preflight.patch \
    && grep -q "BEGIN LOCAL PATCH: conditional atlas preflight checks" recon-all \
    && rm /tmp/0001-conditional-atlas-preflight.patch

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
