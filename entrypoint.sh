#!/usr/bin/env bash

# Add container user
# Either use the settings passed as env vars or the defaults

user_id=${USER_ID:-9001}
user_name=${USER_NAME:-"user"}
user_home=${USER_HOME:-"/home/$user_name"}

echo "user_id: $user_id"
echo "user_name: $user_name"
echo "user_home: $user_home"
useradd --shell /bin/bash -u $user_id -o -c "" -m $user_name
export HOME="$user_home"

exec /usr/local/bin/gosu "$user_name" "$@"
