#!/bin/bash

cpk-launcher-init

# YOUR CODE BELOW THIS LINE
# ----------------------------------------------------------------------------

cpk-exec roslaunch kinect2_bridge kinect2_bridge.launch

# ----------------------------------------------------------------------------
# YOUR CODE ABOVE THIS LINE

cpk-launcher-join
