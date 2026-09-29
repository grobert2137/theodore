# THEODORE
THE Object Dectecting Oriented Robotic Explorer

## OS Versions
### Sept 29 2026
The following ROS and Ubunut versions were chosed to maintain compatibility with the Raspberry Pi AI Cam. As per this article: (https://ubuntu.com/hardware/docs/boards/how-to/special_hardware/rpi-camera/)
- Ubuntu  (24.04)
- ROS2 Jazzy

### Defualt 
#### Dockerfile
```
FROM ros:jazzy-ros-base

RUN apt-get update && apt-get install -y \
    python3-colcon-common-extensions \
    ros-jazzy-rmw-cyclone-cpp \
    && rm -rf /var/lib/apt/lists/*

ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

# Build ROS workspace
WORKDIR /theodore_ws
COPY src ./src
RUN . /opt/ros/jazzy/setup.sh && \
    rosdep update && \
    rosdep install --from-paths src --ignore-src -y && \
    colcon build --symlink-install

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"] 
```

#### Entrypoint
```
#!/bin/bash
source /opt/ros/jazzy/setup.bash
source /theodore_ws/install/setup.bash
exec "$@"
```