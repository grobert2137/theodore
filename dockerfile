## DEVELOPED BY GRANT DAHL 
## SEPT 29 2026

FROM ros:jazzy-ros-base

# Install base packages
RUN apt-get update && apt-get install -y \
    python3-colcon-common-extensions \
    software-properties-common \
    usbutils \
    curl \
    gnupg2 \
    lsb-release \
    build-essential \
    python3-pip \
    python3-opencv \
    git-all \
    nano \
    net-tools \
    iputils-ping \
    iproute2 \
    systemd \
    vim \
    coreutils \
    nlohmann-json3-dev \
    can-utils \
    iproute2 \
    kmod \
    && rm -rf /var/lib/apt/lists/*

# Install Cyclone DDS
RUN apt-get update && apt-get install -y \
    ros-jazzy-rmw-cyclonedds-cpp 

# Set RMW Implementation
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