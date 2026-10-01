#!/bin/sh
# Installs the XRT and IOT headers to build against, into ${XRT}/include and
# ${IOT}/include.
#
# By default they come from the -dev packages of XRT release ${XRT_VERSION},
# from IOTech's Alpine repository ${IOTECH_APK_REPO}. Either can be
# overridden with a directory of headers, copied to /tmp/xrt-include or
# /tmp/iot-include (the xrt-include and iot-include build contexts): an
# include directory, or a directory containing one, such as an install prefix
# or an XRT build's package staging directory.
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

XRT_INCLUDE=$(include_dir /tmp/xrt-include sparkplug/sparkplug_app.h)
IOT_INCLUDE=$(include_dir /tmp/iot-include iot/iot.h)

if [ -z "${XRT_INCLUDE}" ] || [ -z "${IOT_INCLUDE}" ]
then
  wget -q -O /etc/apk/keys/alpine.dev.rsa.pub "${IOTECH_APK_KEY}"
fi

if [ -n "${IOT_INCLUDE}" ]
then
  echo "Using IOT headers from the iot-include build context"
  mkdir -p "${IOT}"
  cp -a "${IOT_INCLUDE}" "${IOT}/include"
else
  apk add --no-cache --repository "${IOTECH_APK_REPO}" iotech-iot-1.6-dev
fi

if [ -n "${XRT_INCLUDE}" ]
then
  echo "Using XRT headers from the xrt-include build context"
  mkdir -p "${XRT}"
  cp -a "${XRT_INCLUDE}" "${XRT}/include"
else
  # Only the headers are taken from the XRT -dev package: installing it would
  # also install the XRT runtime package and its dependencies, but the runtime
  # libraries come from the XRT docker image instead
  wget -q -O /tmp/xrt-dev.apk \
    "${IOTECH_APK_REPO}/$(apk --print-arch)/iotech-xrt-${XRT_VERSION%.*}-dev-${XRT_VERSION}-r0.apk"
  tar -xzf /tmp/xrt-dev.apk -C / opt
  rm /tmp/xrt-dev.apk
fi
