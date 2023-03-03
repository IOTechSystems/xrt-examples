# Container Device Example

## Example

This example demonstrates the usage of XRT components in a container using JSON configuration.

**Required Environment Variables**

You will need to set the following environment variables prior to running the example:

**Run XRT with the config folder:**

This is assuming that the following pre-requisites are satisfied:

- XRT is installed
- LD_LIBRARY_PATH has been correctly set
- XRT_LICENSE_FILE has been set to the location of the xrt license

```bash
cd Container
. ../set_env_vars.sh
xrt deployment/config
```

> **Note** Xrt must be run from this context as the configuration files use relative pathnames
