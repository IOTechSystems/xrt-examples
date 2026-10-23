#!/bin/sh
# Installs the XRT and IOT headers to build against, into ${XRT}/include and
# ${IOT}/include, in an XRT docker image (which has the XRT and IOT runtime
# packages installed, but not their headers).
#
# By default they come from the -dev packages of XRT release ${XRT_VERSION}
# (${XRT_PACKAGE}-dev), from IOTech's apt repository ${IOTECH_APT_REPO}.
# The XRT -dev package depends on exactly that version of the XRT package, so
# apt checks it matches the image's, and the IOT -dev package is pinned to the
# image's IOT version.
#
# Either can be overridden with a directory of headers, copied to
# /tmp/xrt-include or /tmp/iot-include (the xrt-include and iot-include build
# contexts): an include directory, or a directory containing one, such as an
# install prefix or an XRT build's package staging directory.
set -e

# Prints the include directory found in $1 (it or its include/), if it has header $2
include_dir ()
{
  if [ -f "$1/$2" ]
  then
    echo "$1"
  elif [ -f "$1/include/$2" ]
  then
    echo "$1/include"
  fi
}

# Replaces include directory $2 with $1
copy_include ()
{
  rm -rf "$2"
  mkdir -p "$(dirname "$2")"
  cp -a "$1" "$2"
}

XRT_INCLUDE=$(include_dir /tmp/xrt-include sparkplug/sparkplug_app.h)
IOT_INCLUDE=$(include_dir /tmp/iot-include iot/iot.h)

if [ -z "${XRT_INCLUDE}" ] || [ -z "${IOT_INCLUDE}" ]
then
  IOT_PKG_VER=$(dpkg-query -W -f '${Version}' iotech-iot-1.6)
  curl -fsSL "${IOTECH_APT_KEY}" | gpg --dearmor -o /usr/share/keyrings/iotech.gpg
  echo "deb [signed-by=/usr/share/keyrings/iotech.gpg] ${IOTECH_APT_REPO} $(lsb_release -c -s) main" > /etc/apt/sources.list.d/iotech.list
  apt-get update
  if [ -z "${XRT_INCLUDE}" ]
  then
    apt-get install -y --no-install-recommends \
      "${XRT_PACKAGE}-dev=${XRT_VERSION}" "iotech-iot-1.6-dev=${IOT_PKG_VER}"
  else
    apt-get install -y --no-install-recommends "iotech-iot-1.6-dev=${IOT_PKG_VER}"
  fi
fi

if [ -n "${IOT_INCLUDE}" ]
then
  echo "Using IOT headers from the iot-include build context"
  copy_include "${IOT_INCLUDE}" "${IOT}/include"
fi

if [ -n "${XRT_INCLUDE}" ]
then
  echo "Using XRT headers from the xrt-include build context"
  copy_include "${XRT_INCLUDE}" "${XRT}/include"
fi
