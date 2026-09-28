## Prestudy
Here's the goal:
- Learn to understand ROS2 node structure
- Practice writing custom nodes in C++
- Collect data from computer vision sensors
- Learn how to train ML with data from vision
- Apply vision data to controller and state machine

### Overall Progression
```               
                        ROS 2
                           │
             ┌─────────────┴─────────────┐
             │                           │
        PERCEPTION                    CONTROL
             │                           │
     Camera / LiDAR                    Motors
             │                           │
       YOLO / CV                      /cmd_vel
             │                           │
             └──────► DECISION ◄────────┘
                       │
                  "What do I do?"
                       │
              Follow / Stop / Turn
```

### Phase 1: Start with Picar-X
Goal: Make the Picar-X do the following:
1. Detect a color object with the AI Cam
2. Determine it's bounding box
3. Determine whether it's left/right/center
4. Esitmate how far away the obejct is
5. Decide whether to turn/drive/stop.
6. Send motor commands.
7. Repeat at ~10 - 30 Hz.

#### Decision Logic:
```
                    Object detected?
                       /        \
                     NO          YES
                     │            │
                  STOP      Is object too far?
                              /          \
                            YES           NO
                            │              │
                         FORWARD         STOP
                            │
                   Is object left/right?
                      /            \
                   LEFT            RIGHT
                    │                │
                TURN LEFT        TURN RIGHT
```
#### Node Structure:
```
                  ROS 2
                    │
        ┌───────────┼───────────┐
        │           │           │
     Camera       YOLO       Controller
       node        node         node
        │           │           │
        │      detections       │
        └──────────►│──────────►│
                    │           │
                    │        /cmd_vel
                    │           │
                    └───────────┘
```
**Camera Node**
- The Raspberry Pi Camera ecosystem goes through `libcamera`.
    - Use the exisitng `camera_ros ` package rather than writing your own. It publishes the following:
        - `/camera/image_raw`
        - `/camera/camera_info`

**Drive Node**
- `drive_node` subscribes to `/cmd_vel` (or `geometry_msgs/Twist`).
- Main goals for this node is to convert lineaer x into motor speedna nd angular *z* into a steering angle. 
    - The Picar-X is Ackermann-style drive, not differential drive. 

**Percetption Node**
- `yolo_node` subscribes to `/camera/image_raw` and publishes `detections`.
    - It can also publish `/detections/image` with boxes drawn on it for debugging. 

**Control Node**
- Handles `/states`
- Subscribes to all other topics and publishes `/cmd_vel`

**(OPTIONAL) Battery Node**
- Publishes `/battery` or (`sensor_msgs/BatteryState`) to give user info on battery. 
    - "If battery is in critical state <10% then stop robot and turn on buzzer."

### Phase 2: LIDAR Integraton


In progress...

```
                 ┌── Camera ──► YOLO ────────┐
                 │                             │
Robot ───────────┤                             ├──► Decision
                 │                             │
                 └── LiDAR ──► Obstacle Node ─┘
```

### Phase 3: Offload to Nvidia Jetson
```
Raspberry Pi                  Jetson Orin Nano
┌───────────────┐             ┌─────────────────┐
│               │             │                 │
│ Camera        │────────────►│ YOLO            │
│               │    ROS 2    │                 │
│ Motor Control │◄────────────│ Detection       │
│               │             │                 │
└───────────────┘             └─────────────────┘
```





