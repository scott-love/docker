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

## TkSurfer on macOS

The image includes TkSurfer for viewing reconstructed surfaces and editing
labels. The launcher below is for macOS; Linux and Windows have not yet been
tested.

### One-time setup

1. Install and start [Docker Desktop](https://www.docker.com/products/docker-desktop/)
   and [XQuartz](https://www.xquartz.org/).
2. In XQuartz **Settings → Security**, enable **Allow connections from network clients**.
3. Quit XQuartz completely. In Terminal, enable indirect OpenGL and restart XQuartz:

   ```bash
   defaults write org.xquartz.X11 enable_iglx -bool true
   open -a XQuartz
   ```

4. Build the image:

   ```bash
   TAG=2026-11-tksurfer ./build.sh
   ```

### Open a surface

Run the launcher with the directory containing your subject, the subject
name, hemisphere (`lh` or `rh`), and surface name:

```bash
./run-tksurfer-macos.sh "/path/to/subjects" Nitzsche_surf rh white
```

The launcher defaults to `sclove/freesurfer5.3-core:2026-11-tksurfer`.
To use another locally available image, pass it as a fifth argument:

```bash
./run-tksurfer-macos.sh "/path/to/subjects" Nitzsche_surf rh white \
  my-image:my-tag
```

Save labels inside the subject's `label` directory to keep them after the
container exits. The mounted subject directory is writable; back up your
data before editing. Files created by the container may be owned by root.

The launcher uses an XQuartz authentication cookie; do not share it.
XQuartz's network-client setting exposes its display listener, so enable
it only when needed. Avoid disabling X11 access control with `xhost +`.

See the [TkSurfer label guide](https://freesurfer.net/fswiki/TkSurferGuide/TkSurferWorkingWithData/TkSurferLabel)
for drawing and saving labels.

## Freeview on macOS

Freeview uses the same Docker Desktop and XQuartz setup described above.
Build an image containing the Freeview dependencies:

```bash
TAG=2026-11-freeview ./build.sh
```

Launch Freeview with the directory containing your subjects:

```bash
./run-freeview-macos.sh "/path/to/subjects"
```

In Freeview, browse to `/subjects` to open your files. To use a different
locally available image, pass it as the second argument:

```bash
./run-freeview-macos.sh "/path/to/subjects" my-image:my-tag
```

The mounted directory is writable. Back up your data before editing;
files created by the container may be owned by root. Linux and Windows
have not been tested.

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
