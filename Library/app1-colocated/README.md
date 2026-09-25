# App1 - Colocated Sparkplug Client (container)

## Building

Built automatically by `docker compose up --build` from [`../`](../), using
`../` (not this directory) as the build context - the `Dockerfile` needs to
reach [`../vendor/`](../vendor/README.md) too. To build just this image
directly:

```bash
cd Library
docker build -t app1-colocated -f app1-colocated/Dockerfile .
```

## Note on Linking XRT headers

**FOR NOW:** the `Dockerfile` compiles against XRT/IOT headers vendored in
from [`../vendor/`](../vendor/README.md) since they're not currently
publicly available.
