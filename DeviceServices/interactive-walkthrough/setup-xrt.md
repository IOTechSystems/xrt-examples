# Setting up XRT

This page provides steps to setup your environment so that we can easily run XRT.

## Set license file

Replace `<path>` with the full path to your license file.
```bash
export XRT_LICENSE_FILE=<path>/license.lic
```

## Set the environment variables

```bash
source /opt/iotech/xrt/bin/env.sh
```

*Note that this only sets the environment variables for the current session, to persist these environment variables you can add the above commands to .bash_profile or .bashrc (or similar).*
