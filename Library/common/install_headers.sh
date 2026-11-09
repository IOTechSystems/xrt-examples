#!/bin/sh
# Installs the XRT and IOT headers to build against, into ${XRT}/include and
# ${IOT}/include, in an XRT docker image (which has the XRT and IOT runtime
# packages installed, but not their headers).
#
# By default they come from the -dev packages of the image's XRT and IOT
# packages, from IOTech's apt repository ${IOTECH_APT_REPO}.
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
  # -dev packages to install from IOTech's apt repository
  DEV_PACKAGES=""
  if [ -z "${XRT_INCLUDE}" ]
  then
    # The image's XRT package (e.g. iotech-xrt-4.0), unless XRT_PACKAGE is given
    XRT_PACKAGE=${XRT_PACKAGE:-$(dpkg-query -W -f '${db:Status-Abbrev} ${Package}\n' 'iotech-xrt*' | awk '$1 == "ii" && $2 !~ /-(dev|dbg)$/ { print $2; exit }')}
    if [ -z "${XRT_PACKAGE}" ]
    then
      echo "No XRT package installed in the image: set the XRT_PACKAGE build argument, or give XRT headers as the xrt-include build context" >&2
      exit 1
    fi
    XRT_PKG_VER=$(dpkg-query -W -f '${Version}' "${XRT_PACKAGE}")
    DEV_PACKAGES="${XRT_PACKAGE}-dev=${XRT_PKG_VER}"
  fi
  if [ -z "${IOT_INCLUDE}" ]
  then
    # The image's IOT package, e.g. iotech-iot-1.7 for IOT=/opt/iotech/iot/1.7
    IOT_PACKAGE="iotech-iot-${IOT##*/}"
    IOT_PKG_VER=$(dpkg-query -W -f '${Version}' "${IOT_PACKAGE}")
    DEV_PACKAGES="${DEV_PACKAGES} ${IOT_PACKAGE}-dev=${IOT_PKG_VER}"
  fi
  # What adding the repository takes, which not every XRT image has
  apt-get update
  apt-get install -y --no-install-recommends ca-certificates curl gpg lsb-release
  curl -fsSL "${IOTECH_APT_KEY}" | gpg --dearmor -o /usr/share/keyrings/iotech.gpg
  echo "deb [signed-by=/usr/share/keyrings/iotech.gpg] ${IOTECH_APT_REPO} $(lsb_release -c -s) main" > /etc/apt/sources.list.d/iotech.list
  apt-get update
  # shellcheck disable=SC2086 # one word per package
  apt-get install -y --no-install-recommends ${DEV_PACKAGES}
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
