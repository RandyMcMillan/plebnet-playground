#!/bin/bash
set -eo pipefail

shutdown(){

  echo "shutting down container"

#  stop_bitcoin; wait &

  # first shutdown any service started by runit
  for _srv in $(ls -1 /etc/service); do
    sv force-stop $_srv
  done

  echo "shutting down runsvdir"

  # shutdown runsvdir command
  kill -HUP $RUNSVDIR
  wait $RUNSVDIR

  # give processes time to stop
  sleep 0.5

  echo "killing rest processes"
  # kill any other processes still running in the container
  for _pid  in $(ps -eo pid | grep -v PID  | tr -d ' ' | grep -v '^1$' | head -n -6); do
    timeout -t 5 /bin/sh -c "kill $_pid && wait $_pid || kill -9 $_pid"
  done
  exit
}

mkdir -p "${BITCOIN_DIR}"

if [[ ! -f "${BITCOIN_DIR}/bitcoin.conf" ]]; then
  echo "bitcoin.conf file not found in volume, copying to ${BITCOIN_DIR}/bitcoin.conf"
  cp /usr/local/etc/bitcoin.conf "${BITCOIN_DIR}/bitcoin.conf"
else
  echo "bitcoin.conf file exists, skipping."
fi

# ## check services to disable
# for _srv in $(ls -1 /etc/service); do
#     eval X=$`echo -n $_srv | tr [:lower:]- [:upper:]_`_DISABLED
#     [ -n "$X" ] && touch /etc/service/$_srv/down
# done
# chmod logrotate file (#111)
chmod 0644 /etc/logrotate.d/*

exec runsvdir -P /usr/local/etc/service & wait
RUNSVDIR=$!
echo "Started runsvdir, PID is $RUNSVDIR"
echo "wait for processes to start...."

sleep 5
for _srv in $(ls -1 /usr/local/etc/service); do
    sv status $_srv
done

# catch shutdown signals
trap shutdown SIGTERM SIGHUP SIGQUIT SIGINT
wait $RUNSVDIR

shutdown

for arg in $@; do
    echo $arg
done

exec "$@"
