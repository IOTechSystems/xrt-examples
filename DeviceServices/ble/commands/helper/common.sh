# Sourced by the other helper scripts
# Per-user location, as restore_host.sh runs the recorded entries with sudo
STATE_DIR=${XDG_STATE_HOME:-$HOME/.local/state}/xrt-examples
HOST_STATE=$STATE_DIR/ble-sim-host-state

# Returns 0 if the ble-sim container exists, 1 if it does not, 2 if docker could not be queried
sim_exists ()
{
  names=$(docker ps -a --format "{{.Names}}" 2>/dev/null) || return 2
  echo "$names" | grep -qx ble-sim
}
