# sclove/freesurfer5.3-core

Create a docker image of Freesurfer version 5.3.0 without the ```subjects```, ```trctrain```, and ```average``` data to reduce its size to about 3Gb from about 8Gb.

- You MUST read and agree to the license agreement and [register with MGH before you use the software](https://surfer.nmr.mgh.harvard.edu/registration.html).
- Once you have your license, and before building the container, replace the license file in this repository with yours.
- WILL NOT WORK with commands that depend on data within ```subjects```, ```trctrain```, or ```averages``` directories.

## Build the Image
To build the image, either download the files from this repo or clone the repo:
```
git clone https://github.com/scott-love/docker
cd docker/freesurfer/v5.3.0-base/
./build.sh
```
### Example Usage ###
To run a Freesurfer command from this image you can do the following:
```
docker run --rm -ti \
  -v </path/to/input/data>:/subjects \
  sclove/freesurfer5.3-core \
  mri_convert
```
* Note that you are mounting the directory (```-v``` flag) which contains your data in the container at ```/subjects``` and setting this as Freesurfer's default subjects directory.

##### Note that the idea behind and content of this repository follows entirely that of https://github.com/vistalab/docker/tree/master/freesurfer.
