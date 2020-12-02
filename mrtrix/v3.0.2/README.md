# sclove/mrtrix3.0.2

Create a docker image of mrtrix3.0.2

## Build the Image
To build the image, either download the files from this repo or clone the repo:
```
git clone https://github.com/scott-love/docker
cd docker/mrtrix/v3.0.2
./build.sh
```
### Example Usage ###
To run an MRtrix command from this image you can do the following:
```
docker run --rm -ti \
  -v </path/to/input/data>:/data \
  sclove/mrtrix3.0.2 \
  mrconvert
```
* Note that you are mounting the directory (```-v``` flag) which contains your data in the container at ```/data```.
