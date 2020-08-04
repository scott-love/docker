# sclove/freesurfer5.3

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
To run a Freesurfer command (e.g., ```recon-all```) from this image you can do the following:
```
docker run --rm -ti \
  -v </path/to/input/data>:/subjects \
  sclove/freesurfer5.3-core \
  recon-all -i /subjects/<t1_file.nii.gz> -subjid <subjectID> -all
```
* Note that you are mounting the directory (```-v``` flag) which contains your data in the container at ```/input``` and mounting the directory where you want your output data within the container at ```/opt/freesurfer/subjects``` - which is Freesurfer's default subjects directory.

* The name of the freesurfer executable and the args (relative to the contianer) should be provided at the end of the ```docker run``` command. Remember that if those inputs are files or other resources, they must also be mounted in the container and the full path to them (again, relative to the container) must be provided.

##### Note that the idea behind and content of this repository follows entirely that of https://github.com/vistalab/docker/tree/master/freesurfer.
