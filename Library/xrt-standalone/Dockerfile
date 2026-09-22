# "EC Xrt" container in the reference architecture: a *stock* xrt process
# (no custom C app, no library-linked application code) talking to Dev3
# (BACnet/IP) and Dev4 (BACnet MSTP). Just the public runtime image plus a
# startup wrapper that resolves Dev3's simulator address via compose's DNS
# and bridges Dev4's simulated MS/TP bus in, before running `xrt`.
#
# Dev3/Dev4 deliberately use different BACnet datalinks, not just for
# variety: running two XRT::BACnetIPDeviceService instances in one process
# was confirmed (via gdb/tcpdump) to silently break, because the underlying
# bacnet-stack library keeps its BACnet/IP datalink (UDP socket) as
# process-wide global state - two IP instances fight over the one shared
# socket and only the second ever actually sends/receives. BACnet/IP and
# BACnet MSTP are separately compiled bacnet-stack artifacts
# (libbacnet-ip-*.so vs libbacnet-mstp-*.so, both already present in this
# base image), so one of each per process doesn't hit that collision.
FROM iotechsys/xrt-server:3.4.6

# Config files under deployment/config reference ${XRT_STATE_DIR} (e.g.
# bacnet_ip_dev3.json's ProfileDir/StateDir, sparkplug_node.json's StateDir)
# - the stock image doesn't set this, so it must be provided here to match
# where ./deployment is bind-mounted (see ../docker-compose.yml).
ENV XRT_STATE_DIR=/opt/iotech/xrt/3.4/deployment/state

# socat bridges Dev4's simulated MS/TP bus (see entrypoint.sh) in.
RUN apk add --no-cache socat

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
