cmake_minimum_required(VERSION 2.8.3)
project(rangefinder)

## Find catkin macros and libraries
## if COMPONENTS list like find_package(catkin REQUIRED COMPONENTS xyz)
## is used, also find other catkin packages
find_package(catkin REQUIRED COMPONENTS
  roscpp
  rospy
  std_msgs
  sensor_msgs
  message_generation
)


catkin_package(CATKIN_DEPENDS message_runtime)

catkin_package()

include_directories(
  ${catkin_INCLUDE_DIRS}
)

