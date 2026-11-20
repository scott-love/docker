#!/bin/bash
set -euo pipefail

if [ "$#" -lt 4 ] || [ "$#" -gt 5 ]; then
    echo "Usage: $0 SUBJECTS_DIR SUBJECT HEMISPHERE SURFACE [IMAGE]" >&2
    exit 1
fi

subjects=$1
subject=$2
hemi=$3
surface=$4
image="${5:-sclove/freesurfer5.3-core:2026-11-tksurfer}"

if [ "$(uname -s)" != "Darwin" ]; then
    echo "Error: this launcher currently supports macOS only." >&2
    exit 1
fi

for cmd in docker xauth; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: $cmd is not installed or not on PATH." >&2
        exit 1
    fi
done

if [ "$hemi" != "lh" ] && [ "$hemi" != "rh" ]; then
    echo "Error: hemisphere must be lh or rh." >&2
    exit 1
fi

if [ ! -d "$subjects" ]; then
    echo "Error: subjects directory does not exist: $subjects" >&2
    exit 1
fi
subjects=$(cd "$subjects" && pwd -P)

if [ ! -s "$subjects/$subject/surf/$hemi.$surface" ]; then
    echo "Error: surface not found: $subjects/$subject/surf/$hemi.$surface" >&2
    exit 1
fi

if ! docker image inspect "$image" >/dev/null 2>&1; then
    echo "Error: image not found locally: $image" >&2
    exit 1
fi

if ! entries=$(xauth list | awk '$1 ~ /\/unix:0$/ && $2 == "MIT-MAGIC-COOKIE-1" {print $1}'); then
    echo "Error: could not read XQuartz authentication entries." >&2
    exit 1
fi

if [ -z "$entries" ] || [ "$(printf '%s\n' "$entries" | wc -l | tr -d ' ')" != "1" ]; then
    echo "Error: expected one local XQuartz display :0 cookie." >&2
    echo "Check that XQuartz is running and xauth is configured." >&2
    exit 1
fi

umask 077
xauth_file=$(mktemp -t tksurfer-xauth)
trap 'rm -f "$xauth_file"' EXIT

xauth nlist "$entries" | sed 's/^..../ffff/' | xauth -f "$xauth_file" nmerge -
if [ ! -s "$xauth_file" ]; then
    echo "Error: could not prepare the XQuartz cookie." >&2
    exit 1
fi

docker run --rm -it --platform linux/amd64 \
    -w /tmp \
    -e DISPLAY=host.docker.internal:0 \
    -e XAUTHORITY=/tmp/xauth \
    -e LIBGL_ALWAYS_INDIRECT=1 \
    -v "$xauth_file:/tmp/xauth:ro" \
    -v "$subjects:/subjects" \
    "$image" \
    tksurfer "$subject" "$hemi" "$surface"