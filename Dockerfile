# parameters
ARG REPO_NAME="cleandrone"

# ==================================================>
# ==> Do not change this code
ARG ARCH=arm32v7
ARG MAJOR=daffy
ARG BASE_TAG=${MAJOR}-${ARCH}
ARG BASE_IMAGE=dt-ros-commons

# define base image
FROM duckietown/${BASE_IMAGE}:${BASE_TAG}

# define repository path
ARG REPO_NAME
ARG REPO_PATH="${CATKIN_WS_DIR}/src/${REPO_NAME}"

# create repo directory
RUN mkdir -p "${REPO_PATH}"
WORKDIR "${REPO_PATH}"



# TODO
#ENV DEBIAN_FRONTEND=noninteractive
#RUN rm -rf /etc/apt/*
#ADD assets/apt_from_drone /etc/apt/

# raspberry pi stuff
#RUN apt-get update \
#  && apt-get install \
#    --yes \
#    --no-install-recommends \
#    --option Dpkg::Options::="--force-confdef" \
#    --option Dpkg::Options::="--force-confold" \
#        libraspberrypi0 \
#        libraspberrypi-bin \
#        libraspberrypi-dev \
#        libraspberrypi-doc \
#        raspberrypi-bootloader \
#  && rm -rf /var/lib/apt/lists/*

# TODO



# install apt dependencies
COPY ./dependencies-apt.txt "${REPO_PATH}/"
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    $(awk -F: '/^[^#]/ { print $1 }' dependencies-apt.txt | uniq) \
  && rm -rf /var/lib/apt/lists/*




# install python dependencies
COPY ./dependencies-py.txt "${REPO_PATH}/"
RUN pip install -r ${REPO_PATH}/dependencies-py.txt

# copy the source code
COPY . "${REPO_PATH}/"

# build packages
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
  catkin build \
    --workspace ${CATKIN_WS_DIR}/

# define launch script
ENV LAUNCHFILE "${REPO_PATH}/launch.sh"

# define command
CMD ["bash", "-c", "${LAUNCHFILE}"]

# store module name
LABEL org.duckietown.label.module.type="${REPO_NAME}"
ENV DT_MODULE_TYPE "${REPO_NAME}"

# store module metadata
ARG ARCH
ARG MAJOR
ARG BASE_TAG
ARG BASE_IMAGE
LABEL org.duckietown.label.architecture="${ARCH}"
LABEL org.duckietown.label.code.location="${REPO_PATH}"
LABEL org.duckietown.label.code.version.major="${MAJOR}"
LABEL org.duckietown.label.base.image="${BASE_IMAGE}:${BASE_TAG}"
# <== Do not change this code
# <==================================================

MAINTAINER Arthur MacKeith <amackeith@uchicago.edu>
