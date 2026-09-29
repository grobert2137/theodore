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