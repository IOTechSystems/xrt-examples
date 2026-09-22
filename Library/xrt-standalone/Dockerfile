# "EC Xrt" container in the reference architecture: a *stock* xrt process
# (no custom C app, no library-linked application code) talking to Dev3 and
# Dev4. Just the public runtime image plus a startup wrapper that resolves
# each BACnet/IP simulator's address via compose's DNS before running `xrt`.
FROM iotechsys/xrt-server:3.4.6

# Config files under deployment/config reference ${XRT_STATE_DIR} (e.g.
# bacnet_ip_dev3.json's ProfileDir/StateDir, sparkplug_node.json's StateDir)
# - the stock image doesn't set this, so it must be provided here to match
# where ./deployment is bind-mounted (see ../docker-compose.yml).
ENV XRT_STATE_DIR=/opt/iotech/xrt/3.4/deployment/state

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
