#!/bin/sh
# Installs the XRT and IOT headers to build against, into ${XRT}/include and
# ${IOT}/include, in an XRT docker image (which has the XRT and IOT runtime
# packages installed, but not their headers).
#
# They come from the -dev packages of the image's XRT and IOT packages, from
# IOTech's apt repository ${IOTECH_APT_REPO}. The XRT -dev package depends on
# exactly that version of the XRT package, so apt checks it matches the
# image's, and the IOT -dev package is pinned to the image's IOT version.
set -e

# The image's XRT package (e.g. iotech-xrt-4.0)
XRT_PACKAGE=$(dpkg-query -W -f '${db:Status-Abbrev} ${Package}\n' 'iotech-xrt*' | awk '$1 == "ii" && $2 !~ /-(dev|dbg)$/ { print $2; exit }')
if [ -z "${XRT_PACKAGE}" ]
then
  echo "No XRT package installed in the image" >&2
  exit 1
fi
XRT_PKG_VER=$(dpkg-query -W -f '${Version}' "${XRT_PACKAGE}")

# The image's IOT package, e.g. iotech-iot-1.7 for IOT=/opt/iotech/iot/1.7
IOT_PACKAGE="iotech-iot-${IOT##*/}"
IOT_PKG_VER=$(dpkg-query -W -f '${Version}' "${IOT_PACKAGE}")

# What adding the repository takes, which not every XRT image has
apt-get update
apt-get install -y --no-install-recommends ca-certificates curl gpg lsb-release
curl -fsSL "${IOTECH_APT_KEY}" | gpg --dearmor -o /usr/share/keyrings/iotech.gpg
echo "deb [signed-by=/usr/share/keyrings/iotech.gpg] ${IOTECH_APT_REPO} $(lsb_release -c -s) main" > /etc/apt/sources.list.d/iotech.list
apt-get update
apt-get install -y --no-install-recommends \
  "${XRT_PACKAGE}-dev=${XRT_PKG_VER}" "${IOT_PACKAGE}-dev=${IOT_PKG_VER}"
