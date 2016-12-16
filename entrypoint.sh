#!/usr/bin/env bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or fallback

user_id=${LOCAL_USER_ID:-9001}
user_name=${LOCAL_USER_NAME:-"user"}
user_home=${LOCAL_USER_HOME:-"/home/$user_name"}

echo "user_id: $user_id"
echo "user_name: $user_name"
echo "user_home: $user_home"
useradd --shell /bin/bash -u $user_id -o -c "" -m $user_name
export HOME="$user_home"

exec /usr/local/bin/gosu "$user_name" "$@"
