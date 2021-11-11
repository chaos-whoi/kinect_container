# Kinect Container
Containerized version of the [iai_kinect2](https://github.com/code-iai/iai_kinect2)
repository, used to publish kinect data to ROS.

## Setup
+ You need `cpk` in order to be able to build and run this project. Install `cpk` via `pip3` using the command `pip3 install cpk`. For more information on cpk, visit the [cpk repo](https://github.com/afdaniele/cpk)
+ Clone this repository and it's submodules
`git clone --recursive git@github.com:AmyPhung/kinect_container.git`
+ Delete the .git folder in the repo (Note: this is a temporary patch, see [this issue](https://github.com/afdaniele/cpk/issues/16))
+ Navigate to this directory with cd, then run `cpk build`

## Usage
Navigate to the base folder of this repo, then run
```
cpk run -M -f --net=host -- \
  --env=NVIDIA_VISIBLE_DEVICES=all \
  --env=NVIDIA_DRIVER_CAPABILITIES=all \
  --env=DISPLAY --runtime=nvidia \
  --env=QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix
```

## About the cpk build flags:
+ `-f` forces the build to execute, even if the changes aren't logged in git yet

## About the cpk run flags:
+ `--net=host` sets the container to use the same network as the PC, which
allows the container to access things like the internet and the local ROS
network (if one exists)
+ `-M` mounts current project so a rebuild isn't necessary
+ `-f` forces the run to execute, even if the changes aren't logged in git yet
+ `-X` uses x-docker, which allows the graphical stuff to run (e.g. Qt, RVIZ)

## Troubleshooting:
+ OpenCL error
```
[ INFO] [1636665524.064379809]: [DepthRegistration::New] Using OpenCL registration method!
[ INFO] [1636665524.064416078]: [DepthRegistration::New] Using OpenCL registration method!
DRM_IOCTL_I915_GEM_APERTURE failed: Invalid argument
Assuming 131072kB available aperture size.
May lead to reduced performance or incorrect rendering.
get chip id failed: -1 [22]
param: 4, val: 0
beignet-opencl-icd: no supported GPU found, this is probably the wrong opencl-icd package for this hardware
(If you have multiple ICDs installed and OpenCL works, you can ignore this message)
[ INFO] [1636665524.074721475]: [DepthRegistrationOpenCL::init] devices:
[ERROR] [1636665524.074761661]: [DepthRegistrationOpenCL::init] could not find any suitable device
[Info] [Freenect2DeviceImpl] closing...
[Info] [Freenect2DeviceImpl] releasing usb interfaces...
[Info] [Freenect2DeviceImpl] deallocating usb transfer pools...
[Info] [Freenect2DeviceImpl] closing usb device...
[Info] [Freenect2DeviceImpl] closed
[ERROR] [1636665524.075077847]: [Kinect2Bridge::start] Initialization failed!
```
    + Solution: ensure that the flags in the `default.sh` file are set correctly. It should read:
    `roslaunch kinect2_bridge kinect2_bridge.launch depth_method:=opengl reg_method:=cpu`

+ `[Error] [OpenGLDepthPacketProcessorImpl] GLFW error 65544 X11: The DISPLAY environment variable is missing`

    + Solution: When running through cpk, ensure that the nvidia-related flags are set (i.e. `--env=NVIDIA_VISIBLE_DEVICES=all --env=NVIDIA_DRIVER_CAPABILITIES=all --env=DISPLAY --runtime=nvidia --env=QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix`) Note: I'm not sure which ones on this list are unnecessary, but it seems to work if all of them are appended

+ `[Error] [Freenect2Impl] failed to open Kinect v2: @6:4 LIBUSB_ERROR_NO_DEVICE No such device (it may have been disconnected)`
    + Solution: ensure that the `--privileged` flag is set

+ `Internal Server Error ("invalid reference format: repository name must be lowercase")`
    + Solution: Delete the .git folder in the repo (Note: this is a temporary patch, see [this issue](https://github.com/afdaniele/cpk/issues/16))


# TODO:
+ Figure out which flags are unnecessary
+ Fix bug where cpk won't work unless .git folder is removed
