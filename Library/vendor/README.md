# Synced headers (not committed - manual step required for now)

`app1-colocated/Dockerfile` and `app2-standalone/Dockerfile` compile custom C
binaries against XRT/IOT/Paho MQTT/Sparkplug B headers. **All the actual
`.so`s come straight from `iotechsys/xrt-server:3.4.6`** (a multi-stage
`COPY --from=iotechsys/xrt-server:3.4.6 ...` in each Dockerfile) - the same
public, versioned image already used unmodified by `../xrt-standalone/`
(`../xrt-opc-ua-server/` runs a separate, purpose-built image instead - see
its README). Nothing binary is vendored into this repo.

The one thing that image doesn't have is headers: it's a stripped runtime
image (confirmed by `docker run --entrypoint sh iotechsys/xrt-server:3.4.6`
and looking for `include/` - there isn't one). So **only headers** are
needed here, and **none of `vendor/{iot,paho,sparkplug-b,xrt}/` is
committed** - all four are gitignored, so a fresh clone has an empty
`vendor/` (just this README and `sync-apt-headers.sh`) and must be synced
locally before building (see "Syncing this directory" below).

These four fall into two different categories, though, and only one of them
is actually pending anything:

- `iot`/`paho`/`sparkplug-b` are ordinary, already-available IOTech apt
  packages (`iotech-iot-1.6-dev`, `iotech-libpaho-mqtt-1.3`,
  `libsparkplug-b-1.0`). They're gitignored rather than committed purely
  because the Dockerfiles' build stage is Alpine, so it can't `apt install`
  them itself - a host-side apt install + `sync-apt-headers.sh` stands in
  for that. That's just how this build is put together, not something
  waiting on a decision.
- `xrt` is the one actually unresolved piece: there's no confirmed
  `iotech-xrt-dev` apt/apk package name/channel yet (see "Why `xrt/include/`
  still can't come from a real package install" below), so it's still a
  by-hand copy with no sync script. **This is the one worth revisiting if/
  when there's a decision on whether XRT's headers become an installable
  SDK/package** - the other three aren't affected by that either way.

| Directory | Source |
|---|---|
| `xrt/include/` | `xrt` source tree's local CMake build output, the CPack-staged `iotech-xrt-dev-3.4-3.4.6_amd64/include` tree, copied by hand from a machine that had a full local XRT build - this happens to include `devsdk/spg.h`, a header `sparkplug/sparkplug_app.h` needs that a plain package install has been known to miss in the past (documented as a manual `cp` workaround in this example's pre-Docker README); vendoring the whole tree sidesteps that gap without extra effort. See "Why `xrt/include/` still can't come from a real package install" below. |
| `iot/include/` | `iotech-iot-1.6-dev` apt package (`/opt/iotech/iot/1.6/include`) |
| `paho/include/` | `iotech-libpaho-mqtt-1.3` apt package (`/usr/include/MQTT*.h`) |
| `sparkplug-b/include/` | `libsparkplug-b-1.0` apt package (`/usr/include/sparkplug-b`) |

Unlike `xrt/include/`, the `iot`/`paho`/`sparkplug-b` package names and repo
*are* confirmed and already in routine use: all three packages install
cleanly from the IOTech debian-dev apt repo (`/etc/apt/sources.list.d/
iotech.list` on a properly set-up host) and their header trees are
byte-for-byte identical to what gets synced here. They're not installed
directly into the Dockerfiles' build stage only because that stage is
Alpine, not Debian - `apt`/these `.deb`s aren't usable inside it - so a host
machine with these three packages installed is a build-time dependency, and
`sync-apt-headers.sh` in this directory copies the headers out of them:

```
apt-get install iotech-iot-1.6-dev iotech-libpaho-mqtt-1.3 libsparkplug-b-1.0
./vendor/sync-apt-headers.sh
```

Headers are portable C declarations, not compiled code, so it doesn't matter
that they came off a glibc/Ubuntu machine while `iotechsys/xrt-server:3.4.6`
is Alpine/musl - both Dockerfiles use `FROM alpine:3.24` to match that
image's libc for everything that *is* compiled/linked (our own `spg_demo.c`/
`spg_standalone.c`, and the `.so`s pulled from it).

Total size: ~800KB of header text, no binaries.

## Why `xrt/include/` still can't come from a real package install

`iot`/`paho`/`sparkplug-b` are already sourced from real, confirmed apt
packages (see above) - only `xrt/include/` is still a hand copy. The proper
way to get it would be the same `apt-get install`/`apk add` from IOTech's own
package repo, but a confirmed `iotech-xrt-dev-<ver>` (or Alpine
`iotech-xrt-dev-<ver>` via `scripts/iotech-alpine.repo`) package name/channel
wasn't in hand, and the Alpine channel in particular needs real IOTech
credentials substituted into that repo file (`iotech-developer:PASSWORD@...`)
that aren't available here. Revisit this if/when that's sorted - it would
let the last piece of `vendor/` go away entirely.

## Syncing this directory (required before building)

None of `vendor/{iot,paho,sparkplug-b,xrt}/` is in git - all four are
gitignored, so a fresh clone has an empty `vendor/` (just this README and
`sync-apt-headers.sh`) and the Dockerfiles will fail their `COPY vendor/...`
steps until this is done:

- `iot/`, `paho/`, `sparkplug-b/`: install the three apt packages listed
  above on a Debian/Ubuntu host with the IOTech debian-dev repo configured,
  then run `./sync-apt-headers.sh`.
- `xrt/`: copy the `include/` tree by hand from a machine that has a full
  local XRT build - see the "Source" column above. There's no script for
  this one yet since it was a one-off unblock, not a repeatable process.

Re-run both whenever XRT/IOT/Paho/Sparkplug-B change versions, too.
