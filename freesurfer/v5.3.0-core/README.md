# FreeSurfer 5.3.0 Core Docker Image

A lightweight Docker image containing FreeSurfer version 5.3.0.

The image excludes the following data directories to reduce its size from approximately 8 GB to approximately 3 GB:

- `subjects`
- `trctrain`
- `average`

**Important:** Commands that depend on data in these directories will not work unless the required resources are supplied separately.

## License

- You MUST read and agree to the FreeSurfer license agreement and [register with MGH](https://surfer.nmr.mgh.harvard.edu/registration.html) before using the software.
- Once registered, replace the `license` file in this repository with your own FreeSurfer license file before building the image.

## Build the Image

Clone the repository:

```bash
git clone https://github.com/scott-love/docker
cd docker/freesurfer/v5.3.0-core/
```

Build the image using the default settings:

```bash
./build.sh
```

By default, this builds:

`sclove/freesurfer5.3-core:latest`

You can specify a different image tag using the `TAG` environment variable:

```bash
TAG=2026-11-patched ./build.sh
```

You can also specify a different image name:

```bash
IMAGE_NAME=myname/freesurfer TAG=test ./build.sh
```

Alternatively, download the relevant files from this repository.

## Example Usage

To run a FreeSurfer command using this image:

```bash
docker run --rm -ti \
  -v /path/to/input/data:/subjects \
  sclove/freesurfer5.3-core \
  mri_convert
```

The `-v` flag mounts your local data directory inside the container at `/subjects`, which is configured as FreeSurfer's default subjects directory.

## Local Modifications

### Conditional atlas preflight checks

This image includes a local patch to FreeSurfer's `recon-all` script:

`patches/0001-conditional-atlas-preflight.patch`

The original FreeSurfer script performs unconditional checks for several atlas resources, including GCA, GCS and average curvature files. These checks can prevent `recon-all` from running even when the selected processing stages do not require those resources.

The patch makes these checks conditional on the corresponding processing stages:

- **GCA:** checked when GCA-dependent processing is enabled.
- **Skull GCA:** checked when atlas-assisted skull stripping or skull LTA processing is enabled.
- **Average curvature files:** checked when surface registration or average curvature processing is enabled.
- **GCS:** checked when cortical parcellation is enabled.

The patch does not remove FreeSurfer processing functionality. It changes only the preliminary resource checks.

The modification was developed to support a sheep MRI surface-reconstruction workflow using:

```bash
recon-all -autorecon2-wm -noaseg
```

This workflow does not require the human atlas resources removed from this image.

**Patch provenance**

- Upstream version: FreeSurfer 5.3.0
- Original `recon-all` SHA-256: `d44c4b46293a2c6c198f7457920fd87e462bf865e55b9d31db03f7fbde023c03`
- The patched script was tested in the Docker container using the sheep workflow above. The integration run completed successfully.

## Acknowledgements

The idea behind and much of the content of this repository follow the approach of [vistalab/docker – FreeSurfer](https://github.com/vistalab/docker/tree/master/freesurfer).
