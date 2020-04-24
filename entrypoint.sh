#!/bin/sh
export KEYBASE_AUTO_FORK=0
keybase service &
keybase ctl wait
keybase oneshot
exec "$@"
