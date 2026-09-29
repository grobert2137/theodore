# THEODORE
THE Object Dectecting Oriented Robotic Explorer

## OS Versions
### Sept 29 2026
The following ROS and Ubunutu versions were chosen based on compatibility with both the Raspberry Pi 5 SBC and the Nividia Jetson Orin (Nano)
- Ubuntu  (24.04)
- ROS2 Jazzy

## Default Scripts (Updated Sept 29 2026)
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