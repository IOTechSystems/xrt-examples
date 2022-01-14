# SiteWise exporter example

## Example

These examples use the virtual device service to produce readings to be exported by a Sitewise exporter to post readings to an AWS SiteWise service.

## Steps

**Set Environment Variables:**

XRT_PROFILE_DIR - This should be the path to the profile directory e.g

```bash
export XRT_PROFILE_DIR=/path/to/xrt-examples/Exporters/sitewise/config/profiles/
```

XRT_STATE_DIR - This should be the path to the state directory e.g

```bash
export XRT_STATE_DIR=/path/to/xrt-examples/Exporters/sitewise/state/
```

AWS_SITEWISE_ENDPOINT - Your AWS SiteWise endpoint e.g

```bash 
export AWS_SITEWISE_ENDPOINT=https://your-endpoint.amazonaws.com:443/properties
```

AWS_SITEWISE_REGION - Your AWS SiteWise endpoint region e.g

```bash 
export AWS_SITEWISE_REGION=us-east-1
```

AWS_SITEWISE_ACCESS_KEY - Your AWS SiteWise Access Key e.g
```bash 
export AWS_SITEWISE_ACCESS_KEY=[AWS_ACCESS_KEY]
```

AWS_SITEWISE_ACCESS_SECRET_KEY - Your AWS SiteWise Secret Key e.g
```bash
export AWS_SITEWISE_ACCESS_SECRET_KEY=[AWS_ACCESS_SECRET_KEY]
```

**Run XRT with the config folder:**

```bash 
cd sitewise/
xrt deployment/config
```