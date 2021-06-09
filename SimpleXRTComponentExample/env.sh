IOT_DIR=/opt/iotech/iot export IOT_DIR
XRT_DIR=/opt/iotech/xrt export XRT_DIR
PATH=$PATH:$XRT_DIR/bin export PATH
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$XRT_DIR/lib:$IOT_DIR/lib:. export LD_LIBRARY_PATH