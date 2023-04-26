## Run the Example Publisher

**Required Environment Variables**

You will need to set the following environment variables prior to running the example:

XRT_REDIS_BROKER - Address of the redis service

```bash
export XRT_REDIS_BROKER="127.0.0.1"
```

XRT_REDIS_USERNAME - Username set on the server. Set to 'default', Can be overridden using ACL_USER.
Refer [ACL_Redis](https://redis.io/docs/management/security/acl/) for details.

```bash
export XRT_REDIS_USERNAME="default"
```

XRT_REDIS_PASSWORD - Password set with requirepass in redis.conf

```bash
export XRT_REDIS_PASSWORD="foobared"
```

XRT_PROFILE_DIR - This should be the path to the profile directory e.g

```bash
export XRT_PROFILE_DIR=/path/to/xrt-examples/Bridge/redis/pub/deployment/profiles/
```

XRT_STATE_DIR - This should be the path to the state directory e.g

```bash
export XRT_STATE_DIR=/path/to/xrt-examples/Bridge/redis/pub/deployment/state/
```

**Run XRT with the config folder:**

This is assuming that the following pre-requisites are satisfied:

* XRT is installed
* LD_LIBRARY_PATH has been correctly set
* XRT_LICENSE_FILE has been set to the location of the xrt license

```bash
$ cd Bridge/redis/pub
$ xrt deployment/config
```
