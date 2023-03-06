## Run the Example Publisher

**Run XRT with the config folder:**

This is assuming that the following pre-requisites are satisfied:

- XRT is installed
- LD_LIBRARY_PATH has been correctly set
- XRT_LICENSE_FILE has been set to the location of the xrt license

```bash
cd Bridge/mqtt/pub
. ../../../set_env_vars.sh
xrt deployment/config
```

> **Note** Xrt must be run from this context as the configuration files use relative pathnames
