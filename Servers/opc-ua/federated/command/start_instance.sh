#!/bin/sh

if [ $# -ne 2 ]; then
    echo "Usage: $0 <xrt_executable> <instance-id>"
    exit 1
fi

xrtexe=$1
serverid="xrt-instance-$2"
tmpdir="/tmp/$serverid"

rm -rf $tmpdir
mkdir $tmpdir

current_dir_name=$(basename "$(pwd)")
echo ${current_dir_name}

if [ "${current_dir_name}" = "command" ]; then
    cp -r ./../instance_template/* $tmpdir/
else
    cp -r ./instance_template/* $tmpdir/
fi
export XRT_SERVER_ID=$serverid
cd $tmpdir
ls
$xrtexe ./config
