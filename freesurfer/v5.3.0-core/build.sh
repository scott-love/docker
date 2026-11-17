#!/bin/bash
set -e

IMAGE_NAME="${IMAGE_NAME:-sclove/freesurfer5.3-core}"
TAG="${TAG:-latest}"

docker build \
  --platform linux/amd64 \
  -t "${IMAGE_NAME}:${TAG}" \
  .